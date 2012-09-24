require "slimmer/headers"
require "authority_lookup"

class RecordNotFound < Exception
end

class RootController < ApplicationController
  include Rack::Geo::Utils
  include RootHelper
  include ActionView::Helpers::TextHelper
  include Slimmer::Headers
  include ArtefactHelpers

  rescue_from GdsApi::TimedOutException, with: :error_503
  rescue_from GdsApi::EndpointNotFound, with: :error_503

  def index
    set_expiry

    set_slimmer_headers(
      template:    "homepage"
    )

    # Only needed for Analytics
    set_slimmer_dummy_artefact(:section_name => "homepage", :section_url => "/")
  end

  def publication
    error_406 and return if request.format.nil?

    decipher_overloaded_part_parameter!
    merge_slug_for_done_pages!

    @publication = fetch_publication(params)
    assert_found(@publication)
    setup_parts

    @snac_code = nil
    if @publication.type == "licence"
      @snac_code = AuthorityLookup.find_snac(params[:part])
    end

    @artefact = begin
      if @snac_code
        content_api.artefact_with_snac_code(params[:slug], @snac_code).to_hash
      else
        api_request = content_api.artefact(params[:slug])
        api_request.nil? ? artefact_unavailable : api_request.to_hash
      end
    rescue GdsApi::HTTPErrorResponse => e
      logger.debug("Failed to fetch artefact from Content API. Response code: #{e.code}")
      artefact_unavailable
    end
    set_slimmer_artefact_headers(@artefact)

    case @publication.type
    when "place"
      unless request.format.kml?
        set_expiry if params.exclude?('edition') and request.get?
        @options = load_place_options(@publication)
      end
    when "local_transaction"
      @council = load_council(@publication, params[:edition])
    else
      set_expiry if params.exclude?('edition')
    end

    if closest_authority_from_geostack.present?
      @authority = closest_authority_from_geostack
      redirect_to publication_path(:slug => @publication.slug, :part => slug_for_snac_code(closest_authority_from_geostack['ons'])) and return
    end

    if @publication.type == "licence"
      setup_licence
    elsif video_requested_but_not_found? || part_requested_but_not_found? || empty_part_list?
      raise RecordNotFound
    elsif @publication.parts && treat_as_standard_html_request? && @part.nil?
      params.delete(:slug)
      params.delete(:part)
      redirect_to publication_url(@publication.slug, @publication.parts.first.slug, params) and return
    end

    @edition = params[:edition].present? ? params[:edition] : nil

    instance_variable_set("@#{@publication.type}".to_sym, @publication)

    @not_found = false
    respond_to do |format|
      format.html do
        if @publication.type == "local_transaction"
          if @council.present? && @council[:url]
            redirect_to @council[:url] and return
          elsif council_from_geostack.any?
            @not_found = true
          end
        end
        render @publication.type
      end
      format.video do
        render @publication.type, layout: "application.html.erb"
      end
      format.print do
        set_slimmer_headers template: "print"
        render @publication.type
      end
      format.json do
        if @publication.type == "place"
          @publication.places = @options
        elsif @publication.type == "local_transaction"
          @publication.council = @council
        end

        render :json => @publication.to_json
      end
      format.kml do
        if @publication.type == 'place'
          render :text => imminence_api.places_kml(@publication.place_type)
        else
          error_406
        end
      end
    end
  rescue RecordNotFound
    set_expiry
    error 404
  end

  def settings
    respond_to do |format|
      format.html { }
      format.raw { set_slimmer_headers skip: "true"
        render 'settings.html.erb' }
    end
  end

protected
  def decipher_overloaded_part_parameter!
    @provider_not_found = true if params[:part] == "not_found"
  end

  # For completed transaction (done/*) pages, the route will assume that any
  # string after the first slash is the part for a guide. Therefore, join these
  # together before we fetch the publication.
  def merge_slug_for_done_pages!
    if params[:slug] == 'done' and !params[:part].blank?
      params[:slug] += '/' + params[:part]
      params[:part] = nil
    end
  end

  def empty_part_list?
    @publication.parts and @publication.parts.empty?
  end

  def part_requested_but_not_found?
    params[:part] && @publication.parts.blank?
  end

  def video_requested_but_not_found?
    request.format.video? && @publication.video_url.blank?
  end

  # request.format.html? returns 5 when the request format is video.
  def treat_as_standard_html_request?
    !request.format.json? and !request.format.print? and !request.format.video?
  end

  def load_place_options(publication)
    if geo_known_to_at_least?('ward')
      places = imminence_api.places(publication.place_type, geo_header['fuzzy_point']['lat'], geo_header['fuzzy_point']['lon'])
      places.each_with_index {|place,i| places[i]['text'] = places[i]['url'].truncate(36) if places[i]['url'].present? }
      places
    else
      []
    end
  end

  def load_council(local_transaction, edition = nil)
    councils = council_from_geostack
    basic_params = {slug: local_transaction.slug}
    basic_params[:edition] = edition if edition

    unless councils.any?
      return false
    else
      providers = councils.map do |council_ons_code|
        local_transaction = fetch_publication(basic_params.merge(snac: council_ons_code))
        build_local_transaction_information(local_transaction) if local_transaction
      end
      providers.compact!
      provider = providers.select {|council| council[:url] }.first
      if provider
        provider
      else
        providers.select {|council| council[:name]}.first
      end
    end
  end

  def build_local_transaction_information(local_transaction)
    result = {
      url: nil
    }
    if local_transaction.interaction
      result[:url] = local_transaction.interaction.url
      # DEPRECATED: authority is not located inside the interaction in the latest version
      # of publisher. This is here for backwards compatibility.
      if local_transaction.interaction.authority
        result.merge!(build_authority_contact_information(local_transaction.interaction.authority))
      end
      # END DEPRECATED SECTION
    end
    if local_transaction.authority
      result.merge!(build_authority_contact_information(local_transaction.authority))
    end
    result
  end

  def build_authority_contact_information(authority)
    {
      name: authority.name,
      contact_address: authority.contact_address,
      contact_url: authority.contact_url,
      contact_phone: authority.contact_phone,
      contact_email: authority.contact_email
    }
  end

  def fetch_publication(params)
    options = { edition: params[:edition], snac: params[:snac] }.reject { |k, v| v.blank? }
    publisher_api.publication_for_slug(params[:slug], options)
  rescue ArgumentError
    logger.error "invalid UTF-8 byte sequence with slug `#{params[:slug]}`"
    return false
  rescue URI::InvalidURIError
    logger.error "Invalid URI formed with slug `#{params[:slug]}`"
    return false
  end

  def setup_licence
    @licence_from_licensify = @artefact['details']['licence']
    @licence_details = {}

    @licence_details['authorities'] = ( @snac_code and @licence_from_licensify and @licence_from_licensify['authorities'] and @licence_from_licensify['authorities'].any? )

    if @snac_code
      # if we have a licence available for the snac code
      if ! @licence_from_licensify.blank?
        if @licence_details['authorities']
          @licence_authority = @licence_from_licensify['authorities'].first
        else
          raise RecordNotFound
        end

        unless params[:interaction].blank?
          @licence_details["action"] = params[:interaction]

          unless @licence_authority['actions'].keys.include?(@licence_details["action"])
            raise RecordNotFound
          end
        end
      else
        # licence does not exist for this snac code, try and find the council

        # else 404 if the authority slug is incorrect
        # raise RecordNotFound
      end
    else
      # no location
      if @licence_from_licensify.present?
        if @licence_from_licensify['location_specific'] == false
          # does not require location
        end
      else
        # no licence available

      end
    end
  end

  def council_from_geostack
    if params['council_ons_codes']
      params['council_ons_codes']
    else
      full_council_from_geostack.map {|c| c['ons']}.compact
    end
  end

  def full_council_from_geostack
    if ! request.env['HTTP_X_GOVGEO_STACK']
      return []
    end
    location_data = decode_stack(request.env['HTTP_X_GOVGEO_STACK'])
    if location_data['council']
      return location_data['council'].compact
    else
      return []
    end
  end

  def closest_authority_from_geostack
    authorities = full_council_from_geostack
    ["DIS","LBO","UTY","CTY"].each do |type|
      authorities_for_type = authorities.select {|a| a["type"] == type }
      if authorities_for_type.any?
        return authorities_for_type.first
      end
    end
    return false
  end

  def slug_for_snac_code(snac)
    AuthorityLookup.find_slug_from_snac(snac)
  end

  def assert_found(obj)
    raise RecordNotFound unless obj
  end

  def setup_parts
    if @publication.type == 'programme'
      params[:part] ||= @publication.parts.first.slug
    end

    if @publication.parts
      @part = @publication.find_part(params[:part])
    end
  end

  def set_slimmer_artefact_headers(artefact)
    set_slimmer_headers(
      format:      artefact["format"]
    )

    set_slimmer_artefact(artefact)
  end

  def set_expiry
    unless Rails.env.development?
      expires_in(60.minutes, :public => true)
    end
  end
end
