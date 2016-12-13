require "slimmer/headers"
require "authority_lookup"
require "local_transaction_location_identifier"
require "licence_location_identifier"
require "licence_details_from_artefact"
require "postcode_sanitizer"
require "location_error"

class FormatNotSupportedByControllerMethod < StandardError; end

class RootController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_filter -> { setup_content_item_and_navigation_helpers("/" + params[:slug]) }
  before_filter :block_empty_format, only: :publication

  rescue_from FormatNotSupportedByControllerMethod, with: :cacheable_404

  REFACTORED_FORMATS = [
    'answer',
    'business_support',
    'campaign',
    'completed_transaction',
    'guide',
    'help',
    'place',
    'programme',
    'simple_smart_answer',
    'transaction',
    'video',
  ]

  # NOTE: This is a temporary fix to ensure that these licences get treated as
  # 'county/unitary' tiered (as opposed to 'district/unitary'). The tier data
  # for licences used to be stored in LocalService model records in the content
  # api, but the entries for the licences below have since been removed. In
  # future this tier data will be stored in the licensing application
  # (Licensify). Once that has happened and Frontend has been updated to use
  # that tier information, this list and related code in the
  # `appropriate_slug_from_location` method can be removed
  LICENCE_SLUGS_WITH_COUNTY_TIER_OVERRIDE = [
    'scaffolding-and-hoarding-licence',
    'skip-operator-licence',
    'permission-to-place-tables-and-chairs-on-the-pavement',
    'pavement-or-street-display-licence',
    'petroleum-storage-licence',
    'weighbridge-operator-certificate',
    'performing-animals-registration',
    'approval-of-premises-for-civil-marriage-or-civil-partnership',
    'licence-projection-over-highway-england-wales',
  ].freeze

  def publication
    @publication = prepare_publication_and_environment
    raise FormatNotSupportedByControllerMethod if REFACTORED_FORMATS.include?(@publication.format)

    @postcode = PostcodeSanitizer.sanitize(params[:postcode])

    if @publication.format == 'licence'
      mapit_response = fetch_location(@postcode)

      if mapit_response.location_found?
        la_slug = appropriate_slug_from_location(@publication, mapit_response.location)

        if la_slug
          return redirect_to publication_path(slug: params[:slug], part: la_slug)
        else
          @location_error = LocationError.new("noLaMatch")
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
          @location_error = LocationError.new("noLaMatch")
        end
      elsif params[:authority] && params[:authority][:slug].present?
        return redirect_to publication_path(slug: params[:slug], part: CGI.escape(params[:authority][:slug]))
      elsif params[:part]
        begin
          # Check that the part is a valid govuk_slug according to mapit and raise RecordNotFound otherwise
          Frontend.mapit_api.area_for_code("govuk_slug", params[:part])
        rescue GdsApi::HTTPNotFound
          raise RecordNotFound
        end

        authority_slug = params[:part]
      end

      @interaction_details = prepare_interaction_details(@publication, authority_slug)
      if local_authority_match?(@interaction_details)
        @local_authority = LocalAuthorityPresenter.new(@interaction_details['local_authority'])
        if no_interaction?(@interaction_details)
          @location_error = error_for_missing_interaction(@local_authority)
        end
      end
    end

    unless @location_error
      # checking for empty postcode
      @location_error = LocationError.new("invalidPostcodeFormat") if params[:postcode] && @publication.places.nil?
    end

    @edition = params[:edition]

    respond_to do |format|
      format.html.none do
        render @publication.format
      end
      format.json do
        render json: @publication.to_json
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
    artefact = fetch_artefact(params[:slug], params[:edition], nil)
    publication = PublicationPresenter.new(artefact)

    assert_found(publication)
    set_headers_from_publication(publication)

    return publication
  end

  def set_headers_from_publication(publication)
    I18n.locale = publication.language if publication.language
    set_expiry if params.exclude?('edition') and request.get?
    deny_framing if deny_framing?(publication)
  end

  def fetch_location(postcode)
    if postcode.present?
      begin
        location = Frontend.mapit_api.location_for_postcode(postcode)
      rescue GdsApi::HTTPNotFound
        location = nil
      rescue GdsApi::HTTPClientError => e
        error = e
      end
    end
    MapitPostcodeResponse.new(postcode, location, error)
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
    tier_override = :county_unitary if LICENCE_SLUGS_WITH_COUNTY_TIER_OVERRIDE.include?(publication.slug)

    identifier_class = identifier_class_for_format(publication.format)
    identifier_class.find_slug(location.areas, publication.artefact, tier_override)
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
    'local_transaction' == publication.format
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
    LocationError.new(error_code, local_authority_name: local_authority.name)
  end
end
