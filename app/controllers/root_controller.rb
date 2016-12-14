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
    'local_transaction',
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

      @interaction_details = licence_details(@publication.artefact, authority_slug, snac)
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

  def licence_details(artefact, licence_authority_slug, snac_code)
    LicenceDetailsFromArtefact.new(artefact, licence_authority_slug, snac_code, params[:interaction]).build_attributes
  end

  def identifier_class_for_format(format)
    if format == "licence"
      LicenceLocationIdentifier
    else
      raise(Exception, "No location identifier available for #{format}")
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
end
