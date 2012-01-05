require "slimmer/headers"
 
class RecordNotFound < Exception
end

class RootController < ApplicationController
  include Rack::Geo::Utils
  include RootHelper
  include Slimmer::Headers

  def index
    expires_in 10.minute, :public => true unless Rails.env.development?

    set_slimmer_headers(
      template:    "homepage",
      section:     "homepage",
      proposition: "citizen"
    )
  end

  def publication

    decipher_overloaded_part_parameter!

    @publication = fetch_publication(params)
    assert_found(@publication)

    @artefact = fetch_artefact(params)
    set_slimmer_artefact_headers(@artefact)

    if @publication.type == "place"
      @options = load_place_options(@publication)
    else
      expires_in 10.minute, :public => true unless (params.include? 'edition' || Rails.env.development?)
    end

    if video_requested_but_not_found? || part_requested_but_not_found?
      raise RecordNotFound
    elsif @publication.parts && !video_requested?
      params[:part] ||= @publication.parts.first.slug
      @part = @publication.find_part(params[:part])
      redirect_to publication_url(@publication.slug, @publication.parts.first.slug) and return if @part.nil?
    end

    @edition = params[:edition].present? ? params[:edition] : nil

    instance_variable_set("@#{@publication.type}".to_sym, @publication)

    respond_to do |format|
      format.any(:html, :video) do
        render @publication.type
      end
      format.print do
        set_slimmer_headers skip: "true"
        render @publication.type
      end
      format.json do
        render :json => @publication.to_json
      end
    end

  rescue RecordNotFound
    error 404
  end

  def identify_council
    council = publisher_api.council_for_slug(params[:slug], council_ons_from_geostack)

    if council.nil?
      redirect_to publication_path(slug: params[:slug], part: 'not_found', edition: params[:edition]) and return
    end

    local_transaction = fetch_publication(slug: params[:slug], snac: council, edition: params[:edition])
    assert_found(local_transaction && local_transaction.type == "local_transaction")

    redirect_to local_transaction.authority.lgils.last.url and return
  end

  def load_places
    @place = fetch_publication(params)
    assert_found(@place && @place.type == "place")
    places = load_place_options(@place)
    render :json => places
  end

protected
  def decipher_overloaded_part_parameter!
    @provider_not_found = true if params[:part] == "not_found"
  end

  def video_requested?
    request.format.video?
  end

  def part_requested_but_not_found?
    params[:part] && @publication.parts.blank?
  end

  def video_requested_but_not_found?
    video_requested? && @publication.video_url.blank?
  end

  def error_500; error 500; end
  def error_501; error 501; end
  def error_503; error 503; end

  def error(status_code)
    render status: status_code, text: "#{status_code} error"
  end

  def load_place_options(publication)
    if geo_known_to_at_least?('ward')
      imminence_api.places(publication.place_type, geo_header['fuzzy_point']['lat'], geo_header['fuzzy_point']['lon'])
    else
      []
    end
  end

  def fetch_publication(params)
    options = { edition: params[:edition], snac: params[:snac] }.reject { |k, v| v.blank? }
    publisher_api.publication_for_slug(params[:slug], options)
  rescue URI::InvalidURIError
    logger.error "Invalid URI formed with slug `#{params[:slug]}`"
    return false
  end

  def council_ons_from_geostack
    geodata = request.env['HTTP_X_GOVGEO_STACK']
    return [] if geodata.nil?
    location_data = decode_stack(geodata)
    if location_data['council']
      snac_codes = location_data['council'].collect do |council|
        council['ons']
      end.compact
    else
      return []
    end
  end

  def assert_found(obj)
    raise RecordNotFound unless obj
  end

  def set_slimmer_artefact_headers(artefact)
    set_slimmer_headers(
      section:     artefact.section,
      need_id:     artefact.need_id,
      format:      artefact.kind,
      proposition: "citizen"
    )
  end
end
