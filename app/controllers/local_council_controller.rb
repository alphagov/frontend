class LocalCouncilController < ApplicationController
  def index
  end

  def find
    @postcode = params[:postcode]
    local_council = fetch_location(@postcode)
    council_slug = local_council.location.areas.first.codes["govuk_slug"]
    redirect_to "/find-local-council/#{council_slug}"
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

  def result
    # This relies on LocalLinksManager returning the district and council for a district slug
    response = Frontend.local_links_manager_api.local_authority(params[:council_slug])
    @local_authorities = response.local_authorities


    # Alternative implementation that relies on a second request to
    # LocalLinksManager, in the case the LoLiMa cannot return the parent

    # response = Frontend.local_links_manager_api.local_authority(params[:council_slug])
    # @local_authority = response.local_authority

    # if response_local_authority_is_district?
    #   parent_local_authority_response = Frontend.local_links_manager_api.local_authority(@local_authority.parent_slug)
    #   @parent_local_authority = parent_local_authority_response.ocal_authority
    # end

    # then in the view template check if @parent_local_authority is set and display
  end
end


