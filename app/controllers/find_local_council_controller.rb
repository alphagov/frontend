require "postcode_sanitizer"

class FindLocalCouncilController < ContentItemsController
  include Cacheable
  include SplitPostcodeSupport

  skip_before_action :set_locale
  skip_before_action :verify_authenticity_token, only: [:find]

  BASE_PATH = "/find-local-council".freeze

  def index; end

  def find
    @location_error = location_error
    if @location_error
      @postcode = params[:postcode]
      render :index
      return
    end

    return redirect_to "#{BASE_PATH}/#{authority_slug_from_lcc(locations_api_response.local_custodian_codes.first)}" if locations_api_response.single_authority?

    @addresses = address_list
    @options = options
    render :multiple_authorities
  end

  def multiple_authorities
    redirect_to "#{BASE_PATH}/#{params[:authority_slug]}"
  end

  def result
    authority_slug = params[:authority_slug]
    authority_results = Frontend.local_links_manager_api.local_authority(authority_slug)

    if authority_results["local_authorities"].count == 1
      @authority = authority_results["local_authorities"].first

      render :one_council
    else
      # NOTE: Technically we should only get county/district pairs here, but during local authority
      # merge periods, like the 1st April 2023 it is sometimes necessary to have a brief period where
      # a district is still temporarily active but belongs to a unitary authority. If the system
      # gets reengineered this might not be necessary, but for the moment we should allow it.
      @county = authority_results["local_authorities"].detect { |auth| %w[county unitary].include?(auth["tier"]) }
      @district = authority_results["local_authorities"].detect { |auth| auth["tier"] == "district" }

      render :district_and_county_council
    end
  end

private

  def content_item_slug
    BASE_PATH
  end

  def location_error
    return LocationError.new("invalidPostcodeFormat") if locations_api_response.invalid_postcode? || locations_api_response.blank_postcode?

    LocationError.new("noLaMatch") if locations_api_response.location_not_found?
  end

  def locations_api_response
    @locations_api_response ||= fetch_location(postcode)
  end

  def postcode
    @postcode ||= PostcodeSanitizer.sanitize(params[:postcode])
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
end
