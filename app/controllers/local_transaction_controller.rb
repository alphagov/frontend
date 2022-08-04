class LocalTransactionController < ContentItemsController
  include ActionView::Helpers::TextHelper
  include Cacheable

  before_action :deny_framing

  INVALID_POSTCODE = "invalidPostcodeFormat".freeze
  NO_LOCATIONS_API_MATCH = "fullPostcodeNoLocationsApiMatch".freeze
  NO_MATCHING_AUTHORITY = "noLaMatch".freeze
  BANNED_POSTCODES = %w[ENTERPOSTCODE].freeze

  def search
    if request.post?
      @location_error = location_error

      if @location_error
        @postcode = postcode
      elsif locations_api_response.location_found?
        slug = if lgsl == 364 && country_name == "Northern Ireland"
                 "electoral-office-for-northern-ireland"
               else
                 local_authority_slug
               end

        redirect_to local_transaction_results_path(local_authority_slug: slug)
      end
    end
  end

  def results
    @postcode = postcode
    @interaction_details = interaction_details
    @local_authority = LocalAuthorityPresenter.new(@interaction_details["local_authority"])
    @country_name = @local_authority.country_name

    if publication.unavailable?(@country_name)
      render :unavailable_service
    elsif publication.devolved_administration_service?(@country_name)
      render :devolved_administration_service
    else
      render :results
    end
  end

private

  def publication_class
    LocalTransactionPresenter
  end

  def authority_results
    @authority_results = Frontend.local_links_manager_api.local_authority_by_custodian_code(locations_api_response.local_custodian_codes.first)
  rescue GdsApi::HTTPNotFound
    @authority_results = {}
  end

  def local_authority_slug
    authority_results.dig("local_authorities", 0, "slug")
  end

  def country_name
    authority_results.dig("local_authorities", 0, "country_name")
  end

  def location_error
    return LocationError.new(INVALID_POSTCODE) if banned_postcode? || locations_api_response.invalid_postcode? || locations_api_response.blank_postcode?
    return LocationError.new(NO_LOCATIONS_API_MATCH) if locations_api_response.location_not_found?
    return LocationError.new(NO_MATCHING_AUTHORITY) unless local_authority_slug
  end

  def banned_postcode?
    BANNED_POSTCODES.include? postcode
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

  def postcode
    PostcodeSanitizer.sanitize(params[:postcode])
  end

  def lgsl
    content_item_hash["details"]["lgsl_code"]
  end

  def lgil
    content_item_hash["details"]["lgil_code"] || content_item_hash["details"]["lgil_override"]
  end

  def interaction_details
    council = params[:local_authority_slug]

    if council == "electoral-office-for-northern-ireland"
      {
        "local_authority" => {
          "name" => "Electoral Office for Northern Ireland",
          "homepage_url" => "http://www.eoni.org.uk",
          "country_name" => "Northern Ireland",
        },
        "local_interaction" => { "url" => "http://www.eoni.org.uk/Utility/Contact-Us" },
      }
    else
      @_interaction ||= Frontend.local_links_manager_api.local_link(council, lgsl, lgil)
    end
  end
end
