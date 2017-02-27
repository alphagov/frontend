class LicenceController < ApplicationController
  include ApiRedirectable
  include Previewable
  include Cacheable
  include Navigable
  include EducationNavigationABTestable

  before_filter :set_publication

  helper_method :postcode

  INVALID_POSTCODE = 'invalidPostcodeFormat'.freeze
  NO_LOCATION_ERROR = "validPostcodeNoLocation".freeze
  NO_MATCHING_AUTHORITY = 'noLaMatch'.freeze
  NO_MAPIT_MATCH = 'fullPostcodeNoMapitMatch'.freeze

  def search
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
    if @publication.continuation_link.present?
      redirect_to licence_path(slug: params[:slug])
    elsif location_specific_licence?
      raise RecordNotFound unless artefact_with_snac
      @publication = PublicationPresenter.new(artefact_with_snac)
      @interaction_details = licence_details(params[:authority_slug], snac_from_slug)
    else
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
    licence_details[:licence]['location_specific']
  rescue
    false
  end

  def licence_details(authority_slug = nil, snac = nil)
    return {} if @publication.continuation_link.present?

    LicenceDetailsFromLicensify.new(artefact, authority_slug, snac, params[:interaction]).build_attributes
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
      LocalAuthoritySlugFinder.call(mapit_response.location.areas, @licence_details.offered_by_county?)
    end
  end

  def postcode
    PostcodeSanitizer.sanitize(params[:postcode])
  end
end
