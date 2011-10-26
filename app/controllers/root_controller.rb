class RecordNotFound < Exception
end

class RootController < ApplicationController
  include Rack::Geo::Utils
  include RootHelper

  def index
    expires_in 3.minute, :public => true unless Rails.env.development?
    
    headers['X-Slimmer-Template'] = 'homepage'
  end

  def publication
    expires_in 3.minute, :public => true unless Rails.env.development?

    @publication = fetch_publication(params)
    @video_mode = params[:part] == "video"

    assert_found(@publication)

    if @video_mode && @publication.video_url.blank?
      raise RecordNotFound
    elsif !@video_mode && params[:part] && @publication.parts.blank?
      raise RecordNotFound
    elsif @publication.parts
      unless @video_mode
        @partslug = params[:part]
        @part = pick_part(@partslug, @publication)
        assert_found(@part)
      end
    end

    instance_variable_set("@#{@publication.type}".to_sym, @publication)
    respond_to do |format|
      format.html { 
        render @video_mode ? "#{@publication.type}_video" : @publication.type
      }
      format.json { render :json => @publication.to_json }
    end
  rescue RecordNotFound
    render :file => "#{Rails.root}/public/404.html", :layout=>nil, :status=>404
  end

  def autocomplete
    render :json => api.publications
  end

  def identify_council
    @transaction = fetch_publication(params)
    assert_found(@transaction && @transaction.type == "local_transaction")
    snac_codes = council_ons_from_geostack
    council = api.council_for_transaction(@transaction,snac_codes)
    if council.nil?
      flash[:no_council] = "No details of a provider of that service in your area are available"
    end
    redirect_to transaction_path(@slug,council,@edition)
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
    @slug = params[:slug]
    options = {}
    if params[:edition].present? and @edition = params[:edition]
      options[:edition] = params[:edition]
    end
    options[:snac] = params[:snac] if params[:snac]
    publication = api.publication_for_slug(@slug,options)
    if publication && publication.type == "place"
      @options = load_place_options(publication)
    end
    publication
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

  def pick_part(partslug,pub)
     if partslug
        pub.find_part(partslug)
     else
        pub.parts.first
     end
  end
end
