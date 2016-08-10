class FindLocalCouncilController < ApplicationController
  rescue_from RecordNotFound, with: :cacheable_404

  BASE_PATH = "/find-your-local-council"
  UNITARY_AREA_TYPES = %w(COI LBO LGD MTD UTA)
  DISTRICT_AREA_TYPE = "DIS"
  LOWEST_TIER_AREA_TYPES = UNITARY_AREA_TYPES << DISTRICT_AREA_TYPE

  def index
  end

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
    raise RecordNotFound if authority_results.nil?

    if authority_results['local_authorities'].count == 1
      @authority = authority_results['local_authorities'].first

      render :one_council
    else
      # NOTE: the data doesn't support the situation where we get > 1 result
      # and it's anything other than a county and a district, so the obvious
      # problem with this code *shouldn't* happen. (sorry for when it does)
      @county = authority_results['local_authorities'].detect { |auth| auth["tier"] == 'county' }
      @district = authority_results['local_authorities'].detect { |auth| auth["tier"] == 'district' }

      render :district_and_county_council
    end
  end

private

  def location_error
    return LocationError.new unless mapit_response.location_found?
    return LocationError.new('noLaMatch') unless mapit_response.areas_found? && authority_slug.present?
  end

  def mapit_response
    @_mapit_response ||= fetch_location(params[:postcode])
  end

  def authority_slug
    local_council.codes["govuk_slug"]
  end

  def local_council
    @_local_council ||= fetch_local_council_from_areas(mapit_response.location.areas)
  end

  def fetch_local_council_from_areas(areas)
    areas.detect { |a| LOWEST_TIER_AREA_TYPES.include? a.type }
  end

  def fetch_location(postcode)
    if postcode.present?
      begin
        location = Frontend.mapit_api.location_for_postcode(postcode)
      rescue GdsApi::HTTPClientError => e
        error = e
      end
    end
    MapitPostcodeResponse.new(postcode, location, error)
  end
end
