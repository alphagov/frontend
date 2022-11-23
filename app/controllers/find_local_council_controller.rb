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

    return redirect_to "#{BASE_PATH}/#{authority_slug_from_lcc(locations_api_response.local_custodian_codes.first)}" if locations_api_response.single_authority?

    @addresses = address_list
    render :multiple_authorities
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

  def single_authority_from_location_api?
    locations_api_response.local_custodian_codes == 1
  end

  def address_list
    @address_list ||= build_addresses(postcode)
  end

  def build_addresses(postcode)
    base_addresses = fetch_addresses(postcode)
    base_addresses.each do |ba|
      ba["authority_slug"] = authority_slug_from_lcc(ba["local_custodian_code"])
    end
  end

  def postcode
    @postcode ||= PostcodeSanitizer.sanitize(params[:postcode])
  end

  def authority_slug_from_lcc(local_custodian_code)
    authority_results = Frontend.local_links_manager_api.local_authority_by_custodian_code(local_custodian_code)
    authority_results["local_authorities"][0]["slug"]
  end

  def fetch_addresses(postcode)
    # We only do this after fetching location, so relatively safe to miss out
    # some of the safeguards. But we can optimize this a bit
    response = Frontend.locations_api.results_for_postcode(postcode)
    response["results"]
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
