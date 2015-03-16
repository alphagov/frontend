require "slimmer/headers"
require "authority_lookup"
require "local_transaction_location_identifier"
require "licence_location_identifier"
require "licence_details_from_artefact"

class RootController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_filter :set_content_security_policy, :only => [:index]
  before_filter :set_expiry, :only => [:index, :tour]
  before_filter :validate_slug_param, :only => [:publication]
  before_filter :block_empty_format, :only => [:jobsearch, :publication]
  rescue_from RecordNotFound, with: :cacheable_404

  PRINT_FORMATS = %w(guide programme)

  EXCEPTIONAL_FORMAT_SLUGS = %w(
    check-vehicle-tax
    make-a-sorn
    vehicle-tax
    view-driving-licence
  )

  FULL_WIDTH_FORMATS = %w{
    campaign
  }

  def index
    set_slimmer_headers(
      template: "homepage",
      format: "homepage",
      remove_search: true,
    )

    # Only needed for Analytics
    set_slimmer_dummy_artefact(
      section_name: "homepage",
      section_url: "/")

    render locals: { full_width: true }
  end

  def tour
    render locals: { full_width: true }
  end

  def random_page
    # Redirect to a random GOV.UK page, for fun.

    base_url = Plek.new.find('search') + "/unified_search.json"
    total_documents = JSON.parse(RestClient.get("#{base_url}?count=0"))['total']

    random_page_number = Random.rand(0..total_documents-1)

    random_document = RestClient.get("#{base_url}?count=1&fields=link&start=#{random_page_number}")
    result = JSON.parse(random_document)['results'][0]['link']

    # Some paths don't have leading slashes, so add them.
    result = "/#{result}" unless result.starts_with?("/")

    expires_in(5.seconds, :public => true)
    redirect_to Plek.new.website_root + result
  end

  def jobsearch
    @publication = prepare_publication_and_environment
  end

  def legacy_completed_transaction
    @publication = prepare_publication_and_environment
  end

  def publication
    @publication = prepare_publication_and_environment
    @postcode = params[:postcode]

    if ['licence', 'local_transaction'].include?(@publication.format)
      @location = fetch_location @postcode
      if @location
        snac = appropriate_snac_code_from_location(@publication, @location)

        if snac
          redirect_to publication_path(:slug => params[:slug], :part => slug_for_snac_code(snac)) and return
        else
          @location_error = "formats.local_transaction.no_local_authority_html"
        end
      elsif params[:authority] && params[:authority][:slug].present?
        redirect_to publication_path(:slug => params[:slug], :part => CGI.escape(params[:authority][:slug])) and return
      elsif params[:part]
        authority_slug = params[:part]

        unless non_location_specific_licence_present?(@publication)
          snac = AuthorityLookup.find_snac(params[:part])

          if request.format.json?
            redirect_to "/api/#{params[:slug]}.json?snac=#{snac}" and return
          end

          # Fetch the artefact again, for the snac we have
          # This returns additional data based on format and location
          updated_artefact = fetch_artefact(params[:slug], params[:edition], snac, @location) if snac
          assert_found(updated_artefact)
          @publication = PublicationPresenter.new(updated_artefact)
        end
      end

      @interaction_details = prepare_interaction_details(@publication, authority_slug, snac)
    elsif @publication.empty_part_list?
      raise RecordNotFound
    elsif part_requested_but_no_parts? || (@publication.parts && part_requested_but_not_found?)
      redirect_to publication_path(:slug => @publication.slug) and return
    elsif request.format.json? && @publication.format != 'place'
      redirect_to "/api/#{params[:slug]}.json" and return
    end

    @publication.current_part = params[:part]
    @edition = params[:edition]

    respond_to do |format|
      format.html do
        # render bespoke format for specific publications.
        if EXCEPTIONAL_FORMAT_SLUGS.include?(params[:slug])
          render params[:slug], locals: { full_width: true }
        elsif FULL_WIDTH_FORMATS.include?(@publication.format)
          render @publication.format, locals: { full_width: true }
        else
          render @publication.format
        end
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

  def block_empty_format
    raise RecordNotFound if request.format.nil?
  end

  def prepare_publication_and_environment
    publication = publication_with_places(
      params[:postcode], params[:slug], params[:edition]
    )

    assert_found(publication)
    set_headers_from_publication(publication)

    return publication
  end

  def set_headers_from_publication(publication)
    set_slimmer_artefact_headers(publication.artefact)
    I18n.locale = publication.language if publication.language
    set_expiry if params.exclude?('edition') and request.get?
    deny_framing if deny_framing?(publication)
  end

  def publication_with_places(postcode, slug, edition)
    artefact = fetch_artefact(slug, edition, nil)
    places = fetch_places(artefact, postcode)
    publication = PublicationPresenter.new(artefact, places)
    return publication
  end

  def fetch_location(postcode)
    if postcode.present?
      Frontend.mapit_api.location_for_postcode(postcode)
    end
  end

  def fetch_places(artefact, postcode)
    if postcode.present? and artefact.format == 'place'
      Frontend.imminence_api.places_for_postcode(artefact.details.place_type, postcode, 10)
    end
  rescue GdsApi::HTTPErrorResponse => e
    # allow 400 errors, as they can be invalid postcodes people have entered
    raise unless e.code == 400
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

  def non_location_specific_licence_present?(publication)
    publication.format == 'licence' and publication.details['licence'] and !publication.details['licence']['location_specific']
  end

  def deny_framing
    response.headers['X-Frame-Options'] = 'DENY'
  end

  def deny_framing?(publication)
    ['transaction', 'local_transaction'].include? publication.format
  end
end
