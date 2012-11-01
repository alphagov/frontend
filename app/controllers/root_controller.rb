require "slimmer/headers"
require "authority_lookup"
require "local_transaction_location_identifier"
require "licence_location_identifier"

class RootController < ApplicationController
  include Rack::Geo::Utils
  include RootHelper
  include ActionView::Helpers::TextHelper

  before_filter :set_expiry, :only => [:index, :tour]

  def index
    set_slimmer_headers(
      template: "homepage",
      format: "homepage",
      campaign_notification: true)

    # Only needed for Analytics
    set_slimmer_dummy_artefact(
      section_name: "homepage",
      section_url: "/")

    @root_sections = content_api.root_sections.to_hash
  end

  def publication
    error_404 and return if request.format.nil?

    if params[:slug] == 'done' and params[:part].present?
      params[:slug] += "/#{params[:part]}"
      params[:part] = nil
    end

    @artefact = fetch_artefact
    set_slimmer_artefact_headers(@artefact)

    @publication = PublicationPresenter.new(@artefact)
    assert_found(@publication)

    if request.format.json? && @artefact['format'] != 'place'
      redirect_to "/api/#{params[:slug]}.json" and return
    end

    if ['licence','local_transaction'].include? @artefact['format']
      if geo_header and geo_header['council']
        snac = appropriate_snac_code_from_geostack(@artefact)
        redirect_to publication_path(:slug => params[:slug], :part => slug_for_snac_code(snac)) and return
      elsif params[:authority] && params[:authority][:slug].present?
        redirect_to publication_path(:slug => params[:slug], :part => CGI.escape(params[:authority][:slug])) and return
      end

      snac = AuthorityLookup.find_snac(params[:part])
      authority_slug = params[:part]

      # Fetch the artefact again, for the snac we have
      # This returns additional data based on format and location
      @artefact = fetch_artefact(snac) if snac
    elsif (video_requested_but_not_found? || part_requested_but_not_found? || empty_part_list?)
      raise RecordNotFound
    end

    case @publication.type
    when "place"
      @options = load_place_options(@publication)
      @publication.places = @options
    when "licence"
      @licence_details = licence_details(@artefact, authority_slug, snac)
    when "local_transaction"
      @local_transaction_details = local_transaction_details(@artefact, authority_slug, snac)
    end

    set_expiry if params.exclude?('edition') and request.get?

    if @publication.parts
      part = params.fetch(:part){ @publication.parts.first.slug }
      @part = @publication.find_part(part)
    end

    @edition = params[:edition]

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
    set_expiry(10.minutes)
    error 404
  end

protected
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
end
