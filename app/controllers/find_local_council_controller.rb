require "postcode_sanitizer"

class FindLocalCouncilController < ContentItemsController
  include Cacheable
  include SplitPostcodeSupport

  skip_before_action :set_locale
  skip_before_action :verify_authenticity_token, only: [:find]

  BASE_PATH = "/find-local-council".freeze

  def index; end

  def find
    # get location info, raising a LocationError if there's a problem
    postcode_lookup = PostcodeLookup.new(postcode)

    if postcode_lookup.local_custodian_codes.count == 1
      # if location simple, look up authority details and redirect there.
      local_authority = LocalAuthority.from_local_custodian_code(postcode_lookup.local_custodian_codes.first)
      redirect_to "#{BASE_PATH}/#{local_authority.slug}"
    else
      # if location ambiguous, point to multiple authorities
      @addresses = address_list
      @options = options
      render :multiple_authorities
    end
  rescue LocationError => e
    @location_error = e
    render :index
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

  def content_item_path
    BASE_PATH
  end

  def postcode
    @postcode ||= PostcodeSanitizer.sanitize(params[:postcode])
  end
end
