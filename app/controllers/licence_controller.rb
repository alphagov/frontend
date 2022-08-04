class LicenceController < ContentItemsController
  include Previewable
  include Cacheable

  helper_method :postcode, :licence_details

  INVALID_POSTCODE = "invalidPostcodeFormat".freeze
  NO_LOCATION_ERROR = "validPostcodeNoLocation".freeze
  NO_MATCHING_AUTHORITY = "noLaMatch".freeze
  NO_LOCATIONS_API_MATCH = "fullPostcodeNoLocationsApiMatch".freeze

  def start
    if publication.continuation_link.present?
      render :continues_on
    elsif licence_details.local_authority_specific? && postcode_search_submitted?
      @postcode = postcode
      @location_error = location_error

      redirect_to licence_authority_path(slug: params[:slug], authority_slug: local_authority_slug) if local_authority_slug
    elsif licence_details.single_licence_authority_present?
      redirect_to licence_authority_path(slug: params[:slug], authority_slug: licence_details.authority["slug"])
    elsif licence_details.multiple_licence_authorities_present? && authority_choice_submitted?
      redirect_to licence_authority_path(slug: params[:slug], authority_slug: CGI.escape(params[:authority][:slug]))
    end
  end

  def authority
    if publication.continuation_link.present?
      redirect_to licence_path(slug: params[:slug])
    elsif licence_details.local_authority_specific?
      # TODO: Shoud not override @license_details here
      @licence_details = LicenceDetailsPresenter.new(licence_details_from_api_for_local_authority, params[:authority_slug], params[:interaction])
    end
  end

private

  def publication_class
    LicencePresenter
  end

  def licence_details
    @licence_details ||= LicenceDetailsPresenter.new(licence_details_from_api, params["authority_slug"], params[:interaction])
  end

  def licence_details_from_api(snac = nil)
    return {} if publication.continuation_link.present?

    begin
      GdsApi.licence_application.details_for_licence(publication.licence_identifier, snac)
    rescue GdsApi::HTTPErrorResponse => e
      return {} if e.code == 404

      raise
    end
  end

  def licence_details_from_api_for_local_authority
    raise RecordNotFound unless snac_from_slug

    licence_details_from_api(snac_from_slug)
  end

  def snac_from_slug
    local_authority_results = Frontend.local_links_manager_api.local_authority(params[:authority_slug])
    @snac_from_slug = local_authority_results.dig("local_authorities", 0, "snac")
  end

  def postcode_search_submitted?
    params[:postcode] && request.post?
  end

  def authority_choice_submitted?
    params[:authority] && params[:authority][:slug]
  end

  def location_error
    return LocationError.new(INVALID_POSTCODE) if locations_api_response.invalid_postcode? || locations_api_response.blank_postcode?
    return LocationError.new(NO_LOCATIONS_API_MATCH) if locations_api_response.location_not_found?
    return LocationError.new(NO_MATCHING_AUTHORITY) unless local_authority_slug
  end

  def locations_api_response
    @locations_api_response ||= fetch_location(postcode)
  end

  def fetch_location(postcode)
    if postcode.present?
      begin
        local_custodian_codes = Frontend.locations_api.local_custodian_code_for_postcode(postcode)
      rescue GdsApi::HTTPNotFound
        local_custodian_codes = []
      rescue GdsApi::HTTPClientError => e
        error = e
      end
    end
    LocationsApiPostcodeResponse.new(postcode, local_custodian_codes, error)
  end

  def authority_results
    @authority_results ||= Frontend.local_links_manager_api.local_authority_by_custodian_code(locations_api_response.local_custodian_codes.first)
  rescue GdsApi::HTTPNotFound
    @authority_results = {}
  end

  def local_authority_slug
    @local_authority_slug ||= begin
      return nil unless locations_api_response.location_found?

      authority_results.dig("local_authorities", 0, "slug")
    end
  end

  def postcode
    PostcodeSanitizer.sanitize(params[:postcode])
  end
end
