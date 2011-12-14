class RecordNotFound < Exception
end

class RootController < ApplicationController
  include Rack::Geo::Utils
  include RootHelper

  def index
    expires_in 10.minute, :public => true unless Rails.env.development?

    headers['X-Slimmer-Template'] = 'homepage'
    headers["X-Slimmer-Proposition"] = "citizen"
  end

  def publication
    expires_in 10.minute, :public => true unless (params.include? 'edition' || Rails.env.development?)

    @alternative_views = ['video','print','not_found']
    if @alternative_views.include? params[:part]
      @view_mode = params[:part]
      params[:part] = nil
    end

    @publication = fetch_publication(params)
    assert_found(@publication)

    @artefact = fetch_artefact(params)

    set_slimmer_artefact_headers(@artefact)

    if @publication.type == "place"
      @options = load_place_options(@publication)
    end

    if @view_mode == 'video' && @publication.video_url.blank?
      raise RecordNotFound
    elsif !@view_mode && params[:part] && @publication.parts.blank?
      raise RecordNotFound
    elsif @publication.parts
      unless @view_mode == 'video'
        @partslug = params[:part]
        @part = pick_part(@partslug, @publication)
        assert_found(@part)
      end
    end              
                          

    instance_variable_set("@#{@publication.type}".to_sym, @publication)
    respond_to do |format|
      format.html {                                                                 
        if @view_mode == 'print'  
          headers['X-Slimmer-Skip'] = 'true' if @view_mode == 'print'
          render @view_mode ? "#{@publication.type}_#{@view_mode}" : @publication.type, { :layout => "print" }
        else                    
          render @view_mode ? "#{@publication.type}" : @publication.type
        end
      }
      format.json { render :json => @publication.to_json }
    end
  rescue RecordNotFound
    render :file => "#{Rails.root}/public/404.html", :layout=>nil, :status=>404
  end

  def identify_council
    # TODO: Update API adapter so we just get "council_for_slug"
    temporary_transaction = OpenStruct.new(slug: params[:slug])
    snac_codes = council_ons_from_geostack
    council = api.council_for_transaction(temporary_transaction, snac_codes)

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

  def load_place_options(publication)
    if geo_known_to_at_least?('ward')
      places_api.places(publication.place_type, geo_header['fuzzy_point']['lat'], geo_header['fuzzy_point']['lon'])
    else
      []
    end
  end

  def fetch_publication(params)
    options = {}
    if params[:edition].present? and @edition = params[:edition]
      options[:edition] = params[:edition]
    end
    options[:snac] = params[:snac] if params[:snac]

    api.publication_for_slug(params[:slug], options)
  rescue URI::InvalidURIError
    logger.error "Invalid URI formed with slug `#{params[:slug]}`"
    return false
  end
  
  def fetch_artefact(params)
    artefact_api.artefact_for_slug(params[:slug])
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

  def pick_part(partslug, pub)
    if partslug
      pub.find_part(partslug)
    else
      pub.parts.first
    end
  end

  def set_slimmer_artefact_headers(artefact)
    headers["X-Slimmer-Section"]     = artefact.section if artefact.section
    headers["X-Slimmer-Need-ID"]     = artefact.need_id if artefact.need_id
    headers["X-Slimmer-Format"]      = artefact.kind    if artefact.kind
    headers["X-Slimmer-Proposition"] = "citizen"
  end
end
