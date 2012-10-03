require "slimmer/headers"
require "authority_lookup"
require "local_transaction_location_identifier"
require "licence_location_identifier"

class RecordNotFound < Exception
end

class RootController < ApplicationController
  include Rack::Geo::Utils
  include RootHelper
  include ActionView::Helpers::TextHelper
  include ArtefactHelpers

  rescue_from GdsApi::TimedOutException, with: :error_503
  rescue_from GdsApi::EndpointNotFound, with: :error_503
  rescue_from GdsApi::HTTPErrorResponse, with: :error_503

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

    if ['licence','local_transaction'].include? @artefact['format']
      if geo_header and geo_header['council']
        snac = appropriate_snac_code_from_geostack(@artefact)
        redirect_to publication_path(:slug => params[:slug], :part => slug_for_snac_code(snac)) and return
      elsif params[:authority] && params[:authority][:slug].present?
        redirect_to publication_path(:slug => params[:slug], :part => CGI.escape(params[:authority][:slug])) and return
      end

      @snac = AuthorityLookup.find_snac(params[:part])
      @authority_slug = params[:part]

      # Fetch the artefact again, for the snac we have
      # This returns additional data based on format and location
      @artefact = fetch_artefact(@snac) if @snac
    elsif (video_requested_but_not_found? || part_requested_but_not_found? || empty_part_list?)
      raise RecordNotFound
    end

    case @publication.type
    when "place"
      set_expiry if params.exclude?('edition') and request.get?
      @options = load_place_options(@publication)
      @publication.places = @options
    when "programme"
      params[:part] ||= @publication.parts.first.slug
    when "guide"
      params[:part] ||= @publication.parts.first.slug
    when "licence"
      @licence_details = licence_details(@artefact, @authority_slug, @snac)
    when "local_transaction"
      @local_transaction_details = local_transaction_details(@artefact, @authority_slug, @snac)
    else
      set_expiry if params.exclude?('edition')
    end

    if @publication.parts
      @part = @publication.find_part(params[:part])
    end

    @edition = params[:edition]

    instance_variable_set("@#{@publication.type}".to_sym, @publication)

    respond_to do |format|
      format.html do
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
  def fetch_artefact(snac = nil)
    options = { snac: snac }.delete_if { |k,v| v.blank? }
    artefact = content_api.artefact(params[:slug], options)
    unless artefact
      logger.warn("Failed to fetch artefact #{params[:slug]} from Content API. Response code: 404")
      raise RecordNotFound
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
    params[:part] && ! (
      @publication.parts && @publication.parts.any? { |p| p.slug == params[:part] }
    )
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

  def local_transaction_details(artefact, authority_slug, snac)
    if !snac.present? and !authority_slug.blank?
      raise RecordNotFound
    end

    artefact['details'].slice('local_authority', 'local_service', 'local_interaction')
  end

  def licence_details(artefact, licence_authority_slug, snac_code)
    licence_attributes = { licence: artefact['details']['licence'] }

    return false if licence_attributes[:licence].blank? or licence_attributes[:licence]['error'].present?

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

  def appropriate_snac_code_from_geostack(artefact)
    identifier_class = case artefact['format']
                       when "licence" then LicenceLocationIdentifier
                       when "local_transaction" then LocalTransactionLocationIdentifier
                       else raise(Exception, "No location identifier available for #{artefact['format']}")
                       end
    geostack = decode_stack(request.env['HTTP_X_GOVGEO_STACK'])

    identifier_class.find_snac(geostack, artefact)
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
