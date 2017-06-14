class LocalTransactionController < ApplicationController
  include ActionView::Helpers::TextHelper
  include Cacheable
  include Navigable
  include EducationNavigationABTestable

  before_action -> { set_content_item(LocalTransactionPresenter) }
  before_action -> { response.headers['X-Frame-Options'] = 'DENY' }

  INVALID_POSTCODE = 'invalidPostcodeFormat'.freeze
  NO_AUTHORITY_URL = 'laMatchNoLinkNoAuthorityUrl'.freeze
  NO_LINK = 'laMatchNoLink'.freeze
  NO_MAPIT_MATCH = 'fullPostcodeNoMapitMatch'.freeze
  NO_MATCHING_AUTHORITY = 'noLaMatch'.freeze

  def search
    if request.post?
      @location_error = location_error
      if @location_error
        @postcode = postcode
      elsif mapit_response.location_found? && local_authority_slug
        return redirect_to local_transaction_results_path(local_authority_slug: local_authority_slug)
      end
    end
  end

  def results
    @postcode = postcode
    @interaction_details = interaction_details
    @local_authority = local_authority
  end

private

  def local_authority_slug
    @_la_slug ||= LocalTransactionLocationIdentifier.find_slug(mapit_response.location.areas, content_item)
  end

  def location_error
    return LocationError.new(NO_MAPIT_MATCH) if mapit_response.location_not_found?
    return LocationError.new(INVALID_POSTCODE) if mapit_response.invalid_postcode? || mapit_response.blank_postcode?
    return LocationError.new(NO_MATCHING_AUTHORITY) unless local_authority_slug
  end

  def mapit_response
    @_mapit_response ||= location_from_mapit
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
    content_item['details']['lgsl_code']
  end

  def lgil
    content_item['details']['lgil_code'] || content_item['details']['lgil_override']
  end

  def local_authority
    if interaction_details['local_authority']
      local_authority = LocalAuthorityPresenter.new(interaction_details['local_authority'])
    end

    unless interaction_details['local_interaction']
      @location_error = error_for_missing_interaction(local_authority)
    end

    local_authority
  end

  def interaction_details
    council = params[:local_authority_slug]
    return {} unless council
    @_interaction ||= Frontend.local_links_manager_api.local_link(council, lgsl, lgil)
  end

  def error_for_missing_interaction(local_authority)
    error_code = local_authority.url.present? ? NO_LINK : NO_AUTHORITY_URL
    LocationError.new(error_code, local_authority_name: local_authority.name)
  end
end
