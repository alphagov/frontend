require "slimmer/headers"
require "authority_lookup"

class RecordNotFound < Exception
end

class RootController < ApplicationController
  include Rack::Geo::Utils
  include RootHelper
  include ActionView::Helpers::TextHelper
  include ArtefactHelpers

  rescue_from GdsApi::TimedOutException, with: :error_503
  rescue_from GdsApi::EndpointNotFound, with: :error_503

  def index
    set_expiry

    set_slimmer_headers(template: "homepage")

    # Only needed for Analytics
    set_slimmer_dummy_artefact(:section_name => "homepage", :section_url => "/")
  end

  def publication
    error_406 and return if request.format.nil?

    if params[:slug] == 'done' and params[:part].present?
      params[:slug] += "/#{params[:part]}"
      params[:part] = nil
    end

    @artefact = fetch_artefact || artefact_unavailable
    set_slimmer_artefact_headers(@artefact)

    @publication = PublicationPresenter.new(@artefact)
    assert_found(@publication)

    if @publication.type == "licence"
      @snac_code = AuthorityLookup.find_snac(params[:part])
      @licence_authority_slug = params[:part]

      if closest_authority_from_geostack.present? || (params[:authority].present? && params[:authority][:slug].present?)
        part = identify_authority_slug(closest_authority_from_geostack)
        redirect_to publication_path(:slug => @publication.slug, :part => part) and return
      end
    end

    case @publication.type
    when "place"
      set_expiry if params.exclude?('edition') and request.get?
      @options = load_place_options(@publication)
      @publication.places = @options
    when "local_transaction"
      @council = load_council(@publication, params[:edition])
      @publication.council = @council
    when "programme"
      params[:part] ||= @publication.parts.first.slug
    else
      set_expiry if params.exclude?('edition')
    end

    if @publication.parts
      @part = @publication.find_part(params[:part])
    end

    if @publication.type == "licence"
      # Relies on the artefact but could potentially be moved elsewhere
      # once we're loading publications and artefacts in one go
      @licence_details = licence_details(@artefact, @licence_authority_slug, @snac_code)
    elsif video_requested_but_not_found? || part_requested_but_not_found? || empty_part_list?
      raise RecordNotFound
    elsif @publication.parts && treat_as_standard_html_request? && @part.nil?
      params.delete(:slug)
      params.delete(:part)
      redirect_to publication_url(@publication.slug, @publication.parts.first.slug, params) and return
    end

    @edition = params[:edition]

    instance_variable_set("@#{@publication.type}".to_sym, @publication)

    respond_to do |format|
      format.html do
        if @publication.type == "local_transaction"
          @not_found = false
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
        render :json => @publication.to_json
      end
    end
  rescue RecordNotFound
    set_expiry
    error 404
  end

  def settings
    respond_to do |format|
      format.html {}
      format.raw {
        set_slimmer_headers skip: "true"
        render 'settings.html.erb'
      }
    end
  end

protected
  def fetch_artefact
    artefact = @snac_code.blank? ? content_api.artefact(params[:slug]) : content_api.artefact_with_snac_code(params[:slug], @snac_code).to_hash

    unless artefact
      logger.warn("Failed to fetch artefact #{params[:slug]} from Content API. Response code: 404")
    end
    artefact
  rescue URI::InvalidURIError
    logger.warn("Failed to fetch artefact from Content API.")
    raise RecordNotFound
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
    result = {url: nil}
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
    options = {
      edition: params[:edition],
      snac: params[:snac]
    }.reject { |k, v| v.blank? }
    publisher_api.publication_for_slug(params[:slug], options)
  rescue ArgumentError
    logger.error "invalid UTF-8 byte sequence with slug `#{params[:slug]}`"
    return false
  rescue URI::InvalidURIError
    logger.error "Invalid URI formed with slug `#{params[:slug]}`"
    return false
  end

  def licence_details(artefact, licence_authority_slug, snac_code)
    licence_attributes = { licence: artefact['details']['licence'] }

    return false if licence_attributes[:licence].blank?

    licence_attributes[:authority] = authority_for_licence(licence_attributes[:licence], licence_authority_slug, snac_code)

    if ! licence_attributes[:authority] and (snac_code.present? || licence_authority_slug.present?)
      raise RecordNotFound
    end

    if licence_attributes[:authority]
      licence_attributes[:action] = params[:interaction]
      available_actions = licence_attributes[:authority]['actions'].keys + ["apply","renew","change"]

      if licence_attributes[:action] && ! available_actions.include?(licence_attributes[:action])
        raise RecordNotFound
      end
    end

    return licence_attributes
  end

  def authority_for_licence(licence, licence_authority_slug, snac_code)
    if licence["location_specific"]
      if snac_code
        licence['authorities'].first
      end
    else
      if licence['authorities'].size == 1
        licence['authorities'].first
      elsif licence_authority_slug
        licence['authorities'].select {|authority| authority['slug'] == licence_authority_slug }.first
      end
    end
  end

  def identify_authority_slug(closest_authority)
    if closest_authority
      slug_for_snac_code(closest_authority_from_geostack['ons'])
    elsif params[:authority] && params[:authority][:slug].present?
      CGI.escape(params[:authority][:slug])
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
    if !request.env['HTTP_X_GOVGEO_STACK']
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

  def set_slimmer_artefact_headers(artefact)
    set_slimmer_headers(format: artefact["format"])
    set_slimmer_artefact(artefact)
  end

  def set_expiry
    unless Rails.env.development?
      expires_in(60.minutes, :public => true)
    end
  end
end
