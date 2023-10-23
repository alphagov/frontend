class LicenceTransactionController < ContentItemsController
  include Previewable
  include Cacheable
  include SplitPostcodeSupport

  helper_method :licence_details
  before_action :redirect_to_continuation_licence, only: %i[multiple_authorities authority authority_interaction]

  INVALID_POSTCODE = "invalidPostcodeFormat".freeze
  NO_LOCATION_ERROR = "validPostcodeNoLocation".freeze
  NO_MATCHING_AUTHORITY = "noLaMatch".freeze
  NO_LOCATIONS_API_MATCH = "fullPostcodeNoLocationsApiMatch".freeze

  def start
    return render :continues_on if publication.licence_transaction_continuation_link.present?

    return render :licence_not_found if licence_details.licence.blank?

    if licence_details.single_licence_authority_present?
      redirect_to licence_transaction_authority_path(slug: params[:slug], authority_slug: licence_details.authority["slug"])
    end

    @postcode = postcode
  end

  def find
    @location_error = location_error
    if @location_error
      @postcode = postcode
      return render :start
    end

    return redirect_to licence_transaction_authority_path(slug: params[:slug], authority_slug: local_authority_slug) if locations_api_response.single_authority?

    @addresses = address_list
    @options = options
    @change_path = licence_transaction_path(slug: params[:slug])
    @onward_path = licence_transaction_multiple_authorities_path(slug: params[:slug])
    render :multiple_authorities
  end

  def multiple_authorities
    redirect_to licence_transaction_authority_path(slug: params[:slug], authority_slug: params[:authority_slug])
  end

  def authority
    render :licence_not_found unless licence_details.licence.present? && licence_details.has_any_actions?
  end

  def authority_interaction
    render :licence_not_found unless licence_details.licence.present? && licence_details.has_any_actions?
  end

private

  def redirect_to_continuation_licence
    if publication.licence_transaction_continuation_link.present?
      redirect_to licence_transaction_path(slug: params[:slug])
    end
  end

  def content_item_slug
    "/find-licences/#{params[:slug]}"
  end

  def publication_class
    LicenceTransactionPresenter
  end

  def licence_details
    @licence_details ||= fetch_licence_details
  end

  def fetch_licence_details
    details = LicenceDetailsPresenter.new(licence_details_from_api, params[:authority_slug], params[:interaction])
    return details unless params[:authority_slug].present? && details.local_authority_specific?

    LicenceDetailsPresenter.new(licence_details_from_api_for_local_authority, params[:authority_slug], params[:interaction])
  end

  def licence_details_from_api(local_authority_code = nil)
    return {} if publication.licence_transaction_continuation_link.present?

    begin
      GdsApi.licence_application.details_for_licence(publication.licence_transaction_licence_identifier, local_authority_code)
    rescue GdsApi::HTTPErrorResponse => e
      return {} if e.code == 404

      raise
    end
  end

  def licence_details_from_api_for_local_authority
    local_authority_code = local_authority_code_from_slug
    raise RecordNotFound unless local_authority_code

    licence_details_from_api(local_authority_code)
  end

  def local_authority_code_from_slug
    local_authority_results = Frontend.local_links_manager_api.local_authority(params[:authority_slug])
    snac = local_authority_results.dig("local_authorities", 0, "snac")
    return snac if snac

    local_authority_results.dig("local_authorities", 0, "gss")
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
