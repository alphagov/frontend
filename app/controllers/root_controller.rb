require "slimmer/headers"
require "authority_lookup"
require "local_transaction_location_identifier"
require "licence_location_identifier"
require "licence_details_from_artefact"
require "postcode_sanitizer"
require "location_error"

class RootController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_filter :set_content_security_policy, :only => [:index]
  before_filter :set_expiry, :only => [:index, :tour]
  before_filter :validate_slug_param, :only => [:publication]
  before_filter :block_empty_format, :only => [:jobsearch, :publication]
  rescue_from RecordNotFound, with: :cacheable_404

  PRINT_FORMATS = %w(guide programme)

  CUSTOM_SLUGS = {
    "report-child-abuse-to-local-council" => {
      locals: {
        option_partial: "option_report_child_abuse",
        preposition: "for",
      }
    },
    "check-vehicle-tax" => {
      template: "check-vehicle-tax",
      locals: {
        full_width: true
      }
    },
  }

  CUSTOM_FORMATS = {
    "campaign" => {
      locals: {
        full_width: true
      }
    }
  }

  def self.custom_formats; CUSTOM_FORMATS; end
  def self.custom_slugs; CUSTOM_SLUGS; end

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

  def jobsearch
    @publication = prepare_publication_and_environment
  end

  def legacy_completed_transaction
    @publication = prepare_publication_and_environment
  end

  def publication
    @publication = prepare_publication_and_environment
    @postcode = PostcodeSanitizer.sanitize(params[:postcode])

    if @publication.format == 'licence'
      mapit_response = fetch_location(@postcode)

      if mapit_response.location_found?
        la_slug = appropriate_slug_from_location(@publication, mapit_response.location)

        if la_slug
          return redirect_to publication_path(slug: params[:slug], part: la_slug)
        else
          @location_error = LocationError.new("noLaMatchLinkToFindLa")
        end
      elsif params[:authority] && params[:authority][:slug].present?
        return redirect_to publication_path(slug: params[:slug], part: CGI.escape(params[:authority][:slug]))
      elsif params[:part]
        authority_slug = params[:part]

        unless non_location_specific_licence_present?(@publication)
          snac = AuthorityLookup.find_snac_from_slug(params[:part])

          if request.format.json?
            return redirect_to "/api/#{params[:slug]}.json?snac=#{snac}"
          end

          # Fetch the artefact again, for the snac we have
          # This returns additional data based on format and location
          updated_artefact = fetch_artefact(params[:slug], params[:edition], snac) if snac
          assert_found(updated_artefact)
          @publication = PublicationPresenter.new(updated_artefact)
        end
      end

      @interaction_details = prepare_interaction_details(@publication, authority_slug, snac)
    elsif @publication.format == 'local_transaction'

      mapit_response = fetch_location(@postcode)

      if mapit_response.invalid_postcode?
        @location_error = LocationError.new("invalidPostcodeFormat")
      elsif mapit_response.location_not_found?
        @location_error = LocationError.new("fullPostcodeNoMapitMatch")
      elsif mapit_response.location_found?
        # Valid postcode and matching location
        la_slug = appropriate_slug_from_location(@publication, mapit_response.location)

        if la_slug
          # Matching local authority and redirect to publication page
          # with the local authority name. This is the 100% success state.
          # The redirect below redirects back to this action with the `part`
          return redirect_to publication_path(slug: params[:slug], part: la_slug)
        else
          # No matching local authority.
          # This points the user towards "Find your LA" which is an
          # England only service
          @location_error = LocationError.new("noLaMatchLinkToFindLa")
        end
      elsif params[:authority] && params[:authority][:slug].present?
        return redirect_to publication_path(slug: params[:slug], part: CGI.escape(params[:authority][:slug]))
      elsif params[:part]
        # Check that the part is a valid govuk_slug according to mapit and raise RecordNotFound otherwise
        area = Frontend.mapit_api.area_for_code("govuk_slug", params[:part])
        assert_found(area)
        authority_slug = params[:part]
      end

      @interaction_details = prepare_interaction_details(@publication, authority_slug)
      if local_authority_match?(@interaction_details)
        @local_authority = LocalAuthorityPresenter.new(@interaction_details['local_authority'])
        if no_interaction?(@interaction_details)
          @location_error = error_for_missing_interaction(@local_authority)
        end
      end
    elsif @publication.empty_part_list?
      raise RecordNotFound
    elsif part_requested_but_no_parts? || (@publication.parts && part_requested_but_not_found?)
      return redirect_to publication_path(slug: @publication.slug)
    elsif request.format.json? && @publication.format != 'place'
      return redirect_to "/api/#{params[:slug]}.json"
    end

    unless @location_error
      # checking for empty postcode
      @location_error = LocationError.new("invalidPostcodeFormat") if params[:postcode] && @publication.places.nil?
    end

    @publication.current_part = params[:part]
    @edition = params[:edition]

    request.variant = :print if params[:variant].to_s == "print"

    respond_to do |format|
      format.html.none do
        if is_custom_slug?
          render custom_slug_template, locals: custom_slug_locals
        elsif is_custom_format?
          render @publication.format, locals: custom_format_locals
        else
          render @publication.format
        end
      end
      format.html.print do
        if PRINT_FORMATS.include?(@publication.format)
          set_slimmer_headers template: "print"
          render @publication.format, layout: "application.print"
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

  def prepare_interaction_details(publication, authority_slug, snac = nil)
    case publication.format
    when "licence"
      licence_details(publication.artefact, authority_slug, snac)
    when "local_transaction"
      local_transaction_details(publication.artefact, authority_slug)
    end
  end

  def block_empty_format
    raise RecordNotFound if request.format.nil?
  end

  def prepare_publication_and_environment
    publication = publication_with_places(
      PostcodeSanitizer.sanitize(params[:postcode]), params[:slug], params[:edition]
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
      begin
        location = Frontend.mapit_api.location_for_postcode(postcode)
      rescue GdsApi::HTTPClientError => e
        error = e
      end
    end
    MapitPostcodeResponse.new(postcode, location, error)
  end

  def fetch_places(artefact, postcode)
    if postcode.present? and artefact.format == 'place'
      Frontend.imminence_api.places_for_postcode(artefact.details.place_type, postcode, Frontend::IMMINENCE_QUERY_LIMIT)
    end
  rescue GdsApi::HTTPErrorResponse => e
    # allow 400 errors, as they can be invalid postcodes or no locations found
    @location_error = LocationError.new(e.error_details["error"]) unless e.error_details.nil?
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

  def local_transaction_details(artefact, authority_slug)
    return {} unless authority_slug

    lgsl = artefact['details']['lgsl_code']
    lgil = artefact['details']['lgil_override']

    Frontend.local_links_manager_api.local_link(authority_slug, lgsl, lgil)
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

  def appropriate_slug_from_location(publication, location)
    identifier_class = identifier_class_for_format(publication.format)
    identifier_class.find_slug(location.areas, publication.artefact)
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

  def local_authority_match?(interaction_details)
    interaction_details['local_authority']
  end

  def no_interaction?(interaction_details)
    !interaction_details['local_interaction']
  end

  def error_for_missing_interaction(local_authority)
    error_code =
      if local_authority.url.present?
        "laMatchNoLink"
      else
        "laMatchNoLinkNoAuthorityUrl"
      end
    LocationError.new(error_code, { local_authority_name: local_authority.name })
  end

  def is_custom_slug?
    self.class.custom_slugs.key?(params[:slug])
  end

  def custom_slug_template
    self.class.custom_slugs[params[:slug]].fetch(:template, @publication.format)
  end

  def custom_slug_locals
    self.class.custom_slugs[params[:slug]][:locals]
  end

  def is_custom_format?
    self.class.custom_formats.key?(@publication.format)
  end

  def custom_format_locals
    self.class.custom_formats[@publication.format][:locals]
  end
end
