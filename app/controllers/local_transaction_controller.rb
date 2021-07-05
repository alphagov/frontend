API_KEY = "xx"
API_SECRET = "xx"

require "oauth2"

class LocalTransactionController < ApplicationController
  include ActionView::Helpers::TextHelper
  include Cacheable
  include Navigable

  before_action -> { set_content_item(LocalTransactionPresenter) }
  before_action -> { response.headers["X-Frame-Options"] = "DENY" }

  INVALID_POSTCODE = "invalidPostcodeFormat".freeze
  NO_MAPIT_MATCH = "fullPostcodeNoMapitMatch".freeze
  NO_MATCHING_AUTHORITY = "noLaMatch".freeze
  BANNED_POSTCODES = %w[ENTERPOSTCODE].freeze

  def search
    if request.post?
      ## TODO: deal with errors
      local_authority = fetch_location(postcode)

      slug = if lgsl == 364 && country_name == "Northern Ireland"
               "electoral-office-for-northern-ireland"
             else
               local_authority[:slug]
             end

      redirect_to local_transaction_results_path(local_authority_slug: slug)
    end
  end

  def results
    @postcode = postcode
    @interaction_details = interaction_details
    @local_authority = LocalAuthorityPresenter.new(@interaction_details["local_authority"])
    @country_name = @local_authority.country_name

    if @publication.unavailable?(@country_name)
      render :unavailable_service
    elsif @publication.devolved_administration_service?(@country_name)
      render :devolved_administration_service
    else
      render :results
    end
  end

private

  def country_name
    ## TODO: this can be inferred from the first letter of the GSS code
  end

  def banned_postcode?
    BANNED_POSTCODES.include? postcode
  end

  def postcode
    PostcodeSanitizer.sanitize(params[:postcode])
  end

  def lgsl
    content_item["details"]["lgsl_code"]
  end

  def lgil
    content_item["details"]["lgil_code"] || content_item["details"]["lgil_override"]
  end

  def interaction_details
    council = params[:local_authority_slug]

    if council == "electoral-office-for-northern-ireland"
      {
        "local_authority" => { "name" => "Electoral Office for Northern Ireland", "homepage_url" => "http://www.eoni.org.uk" },
        "local_interaction" => { "url" => "http://www.eoni.org.uk/Utility/Contact-Us" },
      }
    else
      @_interaction ||= Frontend.local_links_manager_api.local_link(council, lgsl, lgil)
    end
  end

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
          gss_code = gss_code_from_authority_url(ltla_url)
          slug = slug_from_gss_code(gss_code)
          {gss_code: gss_code, slug: slug}
        else
          gss_code = gss_code_from_authority_url(utla_url)
          slug = slug_from_gss_code(gss_code)
          {gss_code: gss_code, slug: slug}
        end
      else
        ## Postcode maps to more than one LA, so offer the user a choice of addresses, then use the UPRN of their choice to get the LA
        ## TODO: deal with split postcodes
        render plain: "Postcode split over multiple LAs"
      end
    end
  end

  def gss_code_from_authority_url(url)
    uri = URI.parse("#{url.gsub('id', 'doc')}.json") # The gsub is a hack as Net::HTTP doesn't follow redirects
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body).dig(url, "http://data.ordnancesurvey.co.uk/ontology/admingeo/gssCode", 0, "value")
  end

  def slug_from_gss_code(gss_code)
    Frontend.local_links_manager_api.local_authority_by_gss(gss_code).dig("local_authorities", 0, "slug")
  end
end
