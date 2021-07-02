API_KEY = "xx"
API_SECRET = "xx"

require "oauth2"

require "postcode_sanitizer"

class FindLocalCouncilController < ApplicationController
  before_action -> { fetch_and_setup_content_item(BASE_PATH) }
  before_action :set_expiry

  BASE_PATH = "/find-local-council".freeze
  UNITARY_AREA_TYPES = %w[COI LBO LGD MTD UTA].freeze
  DISTRICT_AREA_TYPE = "DIS".freeze
  LOWEST_TIER_AREA_TYPES = [*UNITARY_AREA_TYPES, DISTRICT_AREA_TYPE].freeze

  def index; end

  def find
    ## TODO: deal with errors
    postcode = params[:postcode]
    authority_slug = fetch_location(postcode)

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

  def fetch_location(postcode)
    if postcode.present?

      ## TODO: all of these requests should be moved to postcode-lookup-api (via gds_api_adapters) and made into individual methods (plus we need to implement caching)

      client = OAuth2::Client.new(API_KEY, API_SECRET, site: "https://api.os.uk", token_url: "/oauth2/token/v1")

      token = client.client_credentials.get_token

      response = token.get("/search/places/v1/postcode", params: {postcode: postcode, dataset: "DPA"}) # DPA = Delivery Point Addresses, i.e. postal addresses

      results = JSON.parse(response.body)["results"]

      if results.map { |address| address.dig("DPA", "LOCAL_CUSTODIAN_CODE") }.reject { |code| code == 7655 }.uniq.length == 1  ## 7655 = Ordnance Survey added data, so we can ignore this, needs a more elegant solution
        ## Entire postcode maps to a single local authority (i.e. not a split postcode)
        address = results.first

        ## TODO: Can we get the GSS code without needing to make another 2 queries??
        coordinates = [address.dig("DPA", "X_COORDINATE"), address.dig("DPA", "Y_COORDINATE")].join(",")

        response = token.get("/search/names/v1/nearest", params: {point: coordinates})

        utla_url = JSON.parse(response.body).dig("results", 0, "GAZETTEER_ENTRY", "COUNTY_UNITARY_URI")
        ltla_url = JSON.parse(response.body).dig("results", 0, "GAZETTEER_ENTRY", "DISTRICT_BOROUGH_URI")

        ## We need to return the lowest level of local authority, i.e. the LTLA, unless it is a Unitary Authority, then the UTLA
        if ltla_url
          slug_from_authority_url(ltla_url)
        else
          slug_from_authority_url(utla_url)
        end
      else
        ## Postcode maps to more than one LA, so offer the user a choice of addresses, then use the UPRN of their choice to get the LA
        ## TODO: deal with split postcodes
        render plain: "Postcode split over multiple LAs"
      end
    end
  end

  def slug_from_authority_url(url)
    uri = URI.parse("#{url.gsub('id', 'doc')}.json") # The gsub is a hack as Net::HTTP doesn't follow redirects
    response = Net::HTTP.get_response(uri)
    gss_code = JSON.parse(response.body).dig(url, "http://data.ordnancesurvey.co.uk/ontology/admingeo/gssCode", 0, "value")
    Frontend.local_links_manager_api.local_authority_by_gss(gss_code).dig("local_authorities", 0, "slug")
  end
end
