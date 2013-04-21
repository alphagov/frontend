require "slimmer/headers"
require "authority_lookup"
require "local_transaction_location_identifier"
require "licence_location_identifier"
require "licence_details_from_artefact"

class RootController < ApplicationController
  include RootHelper
  include ActionView::Helpers::TextHelper

  before_filter :set_expiry, :only => [:index, :tour]
  before_filter :validate_slug_param, :only => [:publication]
  rescue_from RecordNotFound, with: :cacheable_404

  PRINT_FORMATS = %w(guide programme)

  def index
    set_slimmer_headers(
      template: "homepage",
      format: "homepage",
      campaign_notification: true)

    # Only needed for Analytics
    set_slimmer_dummy_artefact(
      section_name: "homepage",
      section_url: "/")
  end

  def jobsearch
    prepare_publication_and_environment
  end

  def publication
    prepare_publication_and_environment

    if ['licence', 'local_transaction'].include?(@publication.format)
      if @location
        snac = appropriate_snac_code_from_location(@publication, @location)
        redirect_to publication_path(:slug => params[:slug], :part => slug_for_snac_code(snac)) and return
      elsif params[:authority] && params[:authority][:slug].present?
        redirect_to publication_path(:slug => params[:slug], :part => CGI.escape(params[:authority][:slug])) and return
      elsif params[:part]
        snac = AuthorityLookup.find_snac(params[:part])
        authority_slug = params[:part]

        if request.format.json?
          redirect_to "/api/#{params[:slug]}.json?snac=#{snac}" and return
        end

        # Fetch the artefact again, for the snac we have
        # This returns additional data based on format and location
        updated_artefact = fetch_artefact(params[:slug], params[:edition], snac, @location) if snac
        assert_found(updated_artefact)
        @publication = PublicationPresenter.new(updated_artefact)
      end

      @interaction_details = prepare_interaction_details(@publication, authority_slug, snac)
    elsif part_requested_but_no_parts? || @publication.empty_part_list?
      raise RecordNotFound
    elsif @publication.parts && part_requested_but_not_found?
      redirect_to publication_path(:slug => @publication.slug) and return
    elsif request.format.json? && @publication.format != 'place'
      redirect_to "/api/#{params[:slug]}.json" and return
    end

    @publication.current_part = params[:part]
    @edition = params[:edition]

    respond_to do |format|
      format.html do
        render @publication.format
      end
      format.print do
        if PRINT_FORMATS.include?(@publication.format)
          set_slimmer_headers template: "print"
          render @publication.format
        else
          error_404
        end
      end
      format.json do
        render :json => @publication.to_json
      end
    end
  end

protected

  def prepare_interaction_details(publication, authority_slug, snac)
    case publication.format
    when "licence"
      licence_details(publication.artefact, authority_slug, snac)
    when "local_transaction"
      local_transaction_details(publication.artefact, authority_slug, snac)
    end
  end

  def cacheable_404
    set_expiry(10.minutes)
    error 404
  end

  # This is a method littered with side effects. It pulls together
  # some work that was duplicated in other methods, but in the process
  # sets instance variables and changes global state.
  def prepare_publication_and_environment
    raise RecordNotFound if request.format.nil?

    handle_done_slugs
    @location = setup_location(params[:postcode])

    artefact = fetch_artefact(params[:slug], params[:edition], nil, @location)
    set_slimmer_artefact_headers(artefact)

    @publication = PublicationPresenter.new(artefact)
    assert_found(@publication)

    I18n.locale = @publication.language if @publication.language
    set_expiry if params.exclude?('edition') and request.get?
  end

  # TODO: Can we replace this method with smarter routing?
  def handle_done_slugs
    if params[:slug] == 'done' and params[:part].present?
      params[:slug] += "/#{params[:part]}"
      params[:part] = nil
    end
  end

  def setup_location(postcode)
    if postcode.present?
      Frontend.mapit_api.location_for_postcode(postcode)
    end
  end

  def part_requested_but_no_parts?
    params[:part] && (@publication.parts.nil? || @publication.parts.empty?)
  end

  def part_requested_but_not_found?
    params[:part] && ! @publication.find_part(params[:part])
  end

  # request.format.html? returns 5 when the request format is video.
  def treat_as_standard_html_request?
    !request.format.json? and !request.format.print? and !request.format.video?
  end

  def local_transaction_details(artefact, authority_slug, snac)
    if !snac.present? and !authority_slug.blank?
      raise RecordNotFound
    end

    artefact['details'].slice('local_authority', 'local_service', 'local_interaction')
  end

  def licence_details(artefact, licence_authority_slug, snac_code)
    LicenceDetailsFromArtefact.new(artefact, licence_authority_slug, snac_code, params[:interaction]).build_attributes
  end

  def identifier_class_for_format(format)
    case format
      when "licence" then LicenceLocationIdentifier
      when "local_transaction" then LocalTransactionLocationIdentifier
      else raise(Exception, "No location identifier available for #{format}")
    end
  end

  def appropriate_snac_code_from_location(publication, location)
    # map to legacy geostack format
    geostack = {
      "council" => location.areas.map {|area|
        { "name" => area.name, "type" => area.type, "ons" => area.codes['ons'] }
      }
    }

    identifier_class = identifier_class_for_format(publication.format)
    identifier_class.find_snac(geostack, publication.artefact)
  end

  def slug_for_snac_code(snac)
    AuthorityLookup.find_slug_from_snac(snac)
  end

  def assert_found(obj)
    raise RecordNotFound unless obj
  end
end
