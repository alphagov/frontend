require "slimmer/headers"

class LicenceController < ApplicationController
  include ApiRedirectable
  include Previewable

  before_filter -> { set_expiry unless viewing_draft_content? }
  before_filter -> { setup_content_item_and_navigation_helpers("/" + params[:slug]) }

  helper_method :postcode

  INVALID_POSTCODE = 'invalidPostcodeFormat'.freeze
  NO_LOCATION_ERROR = "validPostcodeNoLocation".freeze
  NO_MATCHING_AUTHORITY = 'noLaMatch'.freeze
  NO_MAPIT_MATCH = 'fullPostcodeNoMapitMatch'.freeze

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

  def search
    @publication = publication
    @interaction_details = licence_details

    if request.post?
      if postcode_search_submitted?
        @postcode = postcode
        @location_error = location_error

        if local_authority_slug
          redirect_to licence_authority_path(slug: params[:slug], authority_slug: local_authority_slug)
        end
      end
    elsif @publication.continuation_link.present?
      render :continues_on
    elsif authority_choice_submitted?
      redirect_to licence_authority_path(slug: params[:slug], authority_slug: CGI.escape(params[:authority][:slug]))
    elsif single_authority_interaction_details_present?
      redirect_to licence_authority_path(slug: params[:slug], authority_slug: @interaction_details[:authority]["slug"])
    end
  end

  def authority
    if publication.continuation_link.present?
      redirect_to licence_path(slug: params[:slug])
    elsif location_specific_licence?
      raise RecordNotFound unless artefact_with_snac
      @publication = PublicationPresenter.new(artefact_with_snac)
      @interaction_details = licence_details_for_snac(params[:authority_slug], snac_from_slug)
    else
      @publication = publication
      @interaction_details = licence_details(params[:authority_slug])
    end
  end

private

  def artefact_with_snac
    return nil if snac_from_slug.blank?

    @_artefact_with_snac ||= ArtefactRetrieverFactory.artefact_retriever.fetch_artefact(
      params[:slug],
      params[:edition],
      snac_from_slug
    )
  end

  def snac_from_slug
    @_snac ||= AuthorityLookup.find_snac_from_slug(params[:authority_slug])
  end

  def postcode_search_submitted?
    params[:postcode]
  end

  def authority_choice_submitted?
    params[:authority] && params[:authority][:slug]
  end

  def single_authority_interaction_details_present?
    @interaction_details && @interaction_details[:authority]
  end

  def location_specific_licence?
    artefact['details']['licence']['location_specific']
  rescue
    false
  end

  def licence_details(authority_slug = nil)
    LicenceDetailsFromArtefact.new(artefact, authority_slug, nil, params[:interaction]).build_attributes
  end

  def licence_details_for_snac(authority_slug, snac)
    LicenceDetailsFromArtefact.new(artefact_with_snac, authority_slug, snac, params[:interaction]).build_attributes
  end

  def location_error
    return LocationError.new(NO_MAPIT_MATCH) if mapit_response.location_not_found?
    return LocationError.new(INVALID_POSTCODE) if mapit_response.invalid_postcode? || mapit_response.blank_postcode?
    return LocationError.new(NO_MATCHING_AUTHORITY) unless local_authority_slug
  end

  def mapit_response
    @_mapit_response ||= location_from_mapit
  end

  def location_from_mapit
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

  def local_authority_slug
    return nil unless mapit_response.location_found?

    @_la_slug ||= begin
      tier_override = :county_unitary if LICENCE_SLUGS_WITH_COUNTY_TIER_OVERRIDE.include?(params['slug'])
      LicenceLocationIdentifier.find_slug(mapit_response.location.areas, artefact, tier_override)
    end
  end

  def appropriate_slug_from_location(publication, location)
    tier_override = :county_unitary if LICENCE_SLUGS_WITH_COUNTY_TIER_OVERRIDE.include?(publication.slug)
    LicenceLocationIdentifier.find_slug(location.areas, publication.artefact, tier_override)
  end

  def postcode
    PostcodeSanitizer.sanitize(params[:postcode])
  end
end
