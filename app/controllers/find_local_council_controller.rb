require "postcode_sanitizer"

class FindLocalCouncilController < ApplicationController
  before_filter :set_artefact_headers

  rescue_from RecordNotFound, with: :cacheable_404

  BASE_PATH = "/find-local-council"
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
    return LocationError.new("invalidPostcodeFormat") if mapit_response.invalid_postcode? || mapit_response.blank_postcode?
    return LocationError.new("fullPostcodeNoMapitMatch") if mapit_response.location_not_found?
    return LocationError.new("noLaMatch") unless mapit_response.location_found? && mapit_response.areas_found? && authority_slug.present?
  end

  def mapit_response
    @_mapit_response ||= fetch_location(postcode)
  end

  def postcode
    @_postcode ||= PostcodeSanitizer.sanitize(params[:postcode])
  end

  def authority_slug
    local_council.codes["govuk_slug"]
  end

  def local_council
    @_local_council ||= fetch_local_council_from_areas(mapit_response.location.areas)
  end

  def set_artefact_headers
    set_slimmer_artefact_headers(dummy_artefact_with_hardcoded_links)
  end

  def dummy_artefact_with_hardcoded_links
    # NOTE: We use a hash as a dummy artefact (which stores a variety of
    #       hardcoded data) for the moment, until we decide if we
    #       can store this and other related data on a content item
    hardcoded_format
      .merge(hardcoded_related_links)
      .merge(hardcoded_breadcrumbs)
  end

  def hardcoded_format
    # NOTE: This is required to set 'dimension2' for Google Analytics tracking
    {
      "format" => "find-local-council",
    }
  end

  def hardcoded_related_links
    {
      "related" => [
        {
          "id" => "https://www.gov.uk/api/understand-how-your-council-works.json",
          "content_id" => "df61f873-f42f-4fb9-8e8e-17fa6a583270",
          "web_url" => "https://www.gov.uk/understand-how-your-council-works",
          "title" => "Understand how your council works",
          "format" => "guide",
          "owning_app" => "publisher",
          "in_beta" => false,
          "updated_at" => "2014-10-22T16:24:06+01:00",
          "group" => "subsection"
        },
      ]
    }
  end

  def hardcoded_breadcrumbs
    {
      "tags" => [
        {
          "id" => "https://www.gov.uk/api/tags/section/housing-local-services%2Flocal-councils.json",
          "content_id" => "4f8f62a8-9ff9-45ab-b4f7-aec5d1cffbad",
          "slug" => "housing-local-services/local-councils",
          "web_url" => "https://www.gov.uk/browse/housing-local-services/local-councils",
          "title" => "Local councils and services",
          "details" => {
            "description" => "Find and access local services",
            "short_description" => nil,
            "type" => "section"
          },
          "content_with_tag" => {
            "id" => "https://www.gov.uk/api/with_tag.json?section=housing-local-services%2Flocal-councils",
            "web_url" => "https://www.gov.uk/browse/housing-local-services/local-councils"
          },
          "state" => "live",
          "parent" => {
            "id" => "https://www.gov.uk/api/tags/section/housing-local-services.json",
            "content_id" => "61d038ad-ba54-40a1-b6ca-18b390138b41",
            "slug" => "housing-local-services",
            "web_url" => "https://www.gov.uk/browse/housing-local-services",
            "title" => "Housing and local services",
            "details" => {
              "description" => "Includes owning or renting, council services, planning and building, neighbours, noise and pets",
              "short_description" => nil,
              "type" => "section"
            },
            "content_with_tag" => {
              "id" => "https://www.gov.uk/api/with_tag.json?section=housing-local-services",
              "web_url" => "https://www.gov.uk/browse/housing-local-services"
            },
            "state" => "live",
            "parent" => nil
          }
        }
      ],
    }
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
