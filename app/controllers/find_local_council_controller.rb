require "postcode_sanitizer"

class FindLocalCouncilController < ContentItemsController
  include Cacheable

  skip_before_action :set_locale

  BASE_PATH = "/find-local-council".freeze

  def index; end

  def find
    @location_error = location_error
    if @location_error
      @postcode = params[:postcode]
      render :index
      return
    end

    redirect_to "#{BASE_PATH}/#{authority_slug}"
  end

  def result
    authority_slug = params[:authority_slug]
    authority_results = Frontend.local_links_manager_api.local_authority(authority_slug)

    if authority_results["local_authorities"].count == 1
      @authority = authority_results["local_authorities"].first

      render :one_council
    else
      # NOTE: the data doesn't support the situation where we get > 1 result
      # and it's anything other than a county and a district, so the obvious
      # problem with this code *shouldn't* happen. (sorry for when it does)
      @county = authority_results["local_authorities"].detect { |auth| auth["tier"] == "county" }
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
    return LocationError.new("noLaMatch") if locations_api_response.location_not_found?
  end

  def locations_api_response
    @locations_api_response ||= fetch_location(postcode)
  end

  def postcode
    @postcode ||= PostcodeSanitizer.sanitize(params[:postcode])
  end

  def authority_slug
    authority_results = Frontend.local_links_manager_api.local_authority_by_custodian_code(locations_api_response.local_custodian_codes.first)
    authority_results["local_authorities"][0]["slug"]
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
