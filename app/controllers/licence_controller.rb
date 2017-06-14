class LicenceController < ApplicationController
  include Previewable
  include Cacheable
  include Navigable
  include EducationNavigationABTestable

  before_action :set_content_item

  helper_method :postcode

  INVALID_POSTCODE = 'invalidPostcodeFormat'.freeze
  NO_LOCATION_ERROR = "validPostcodeNoLocation".freeze
  NO_MATCHING_AUTHORITY = 'noLaMatch'.freeze
  NO_MAPIT_MATCH = 'fullPostcodeNoMapitMatch'.freeze

  def start
    if @publication.continuation_link.present?
      render :continues_on
    elsif @licence_details.local_authority_specific? && postcode_search_submitted?
      @postcode = postcode
      @location_error = location_error

      redirect_to licence_authority_path(slug: params[:slug], authority_slug: local_authority_slug) if local_authority_slug
    elsif @licence_details.single_licence_authority_present?
      redirect_to licence_authority_path(slug: params[:slug], authority_slug: @licence_details.authority['slug'])
    elsif @licence_details.multiple_licence_authorities_present? && authority_choice_submitted?
      redirect_to licence_authority_path(slug: params[:slug], authority_slug: CGI.escape(params[:authority][:slug]))
    end
  end

  def authority
    if @publication.continuation_link.present?
      redirect_to licence_path(slug: params[:slug])
    elsif @licence_details.local_authority_specific?
      @licence_details = LicenceDetailsPresenter.new(licence_details_from_api_for_local_authority, nil, params[:interaction])
    end
  end

private

  def set_content_item
    super(LicencePresenter)
    @licence_details = LicenceDetailsPresenter.new(licence_details_from_api, params["authority_slug"], params[:interaction])
  end

  def licence_details_from_api(snac = nil)
    return {} if @publication.continuation_link.present?

    begin
      Services.licensify.details_for_licence(@publication.licence_identifier, snac)
    rescue GdsApi::HTTPErrorResponse, GdsApi::TimedOutException
      {}
    end
  end

  def licence_details_from_api_for_local_authority
    raise RecordNotFound unless snac_from_slug
    licence_details_from_api(snac_from_slug)
  end

  def snac_from_slug
    @_snac ||= AuthorityLookup.find_snac_from_slug(params[:authority_slug])
  end

  def postcode_search_submitted?
    params[:postcode] && request.post?
  end

  def authority_choice_submitted?
    params[:authority] && params[:authority][:slug]
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
