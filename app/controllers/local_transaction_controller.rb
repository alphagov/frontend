class LocalTransactionController < ContentItemsController
  include ActionView::Helpers::TextHelper
  include Cacheable

  before_action :deny_framing

  INVALID_POSTCODE = "invalidPostcodeFormat".freeze
  NO_MAPIT_MATCH = "fullPostcodeNoMapitMatch".freeze
  NO_MATCHING_AUTHORITY = "noLaMatch".freeze
  BANNED_POSTCODES = %w[ENTERPOSTCODE].freeze

  def search
    if request.post?
      @location_error = location_error

      if @location_error
        @postcode = postcode
      elsif mapit_response.location_found?
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

  def local_authority_slug
    @local_authority_slug ||= LocalTransactionLocationIdentifier.find_slug(mapit_response.location.areas, content_item_hash)
  end

  def country_name
    @country_name ||= LocalTransactionLocationIdentifier.find_country(mapit_response.location.areas, content_item_hash)
  end

  def location_error
    return LocationError.new(INVALID_POSTCODE) if banned_postcode? || mapit_response.invalid_postcode? || mapit_response.blank_postcode?
    return LocationError.new(NO_MAPIT_MATCH) if mapit_response.location_not_found?
    return LocationError.new(NO_MATCHING_AUTHORITY) unless local_authority_slug
  end

  def banned_postcode?
    BANNED_POSTCODES.include? postcode
  end

  def mapit_response
    @mapit_response ||= location_from_mapit
  end

  def location_from_mapit
    if postcode.present?
      begin
        location = Frontend.mapit_api.location_for_postcode(postcode)
      rescue GdsApi::HTTPNotFound
        location = nil
      rescue GdsApi::HTTPClientError => e
        error = e
      end
    end
    MapitPostcodeResponse.new(postcode, location, error)
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
