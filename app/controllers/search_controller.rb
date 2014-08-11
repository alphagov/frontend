require "slimmer/headers"

class SearchController < ApplicationController

  before_filter :setup_slimmer_artefact, only: :index
  before_filter :set_expiry

  rescue_from GdsApi::BaseError, with: :error_503

  DEFAULT_RESULTS_PER_PAGE = 50
  MAX_RESULTS_PER_PAGE = 100

  def index
    @search_term = params[:q]
    if @search_term.blank? && params[:format] != "json"
      render action: 'no_search_term' and return
    end

    search_params = {
      start: params[:start],
      count: "#{requested_result_count}",
      q: @search_term,
      filter_organisations: [*params[:filter_organisations]],
      fields: %w{
        description
        display_type
        document_series
        format
        link
        organisations
        organisation_state
        public_timestamp
        section
        slug
        specialist_sectors
        subsection
        subsubsection
        title
        topics
        world_locations
      },
      facet_organisations: "100",
      debug: params[:debug],
    }
    search_response = search_client.unified_search(search_params)

    presented_params = params.merge(
      count: requested_result_count,
    )
    @results = SearchResultsPresenter.new(search_response, @search_term, presented_params)
    @facets = search_response["facets"]
    @spelling_suggestion = @results.spelling_suggestion

    fill_in_slimmer_headers(@results.result_count)

    respond_to do |format|
      format.html
      format.json do
        render json: @results
      end
    end
  end

protected

  def requested_result_count
    count = request.query_parameters["count"]
    count = count.nil? ? 0 : count.to_i
    if count <= 0
      count = DEFAULT_RESULTS_PER_PAGE
    elsif count > MAX_RESULTS_PER_PAGE
      count = MAX_RESULTS_PER_PAGE
    end
    count
  end

  def search_client
    Frontend.search_client
  end

  def fill_in_slimmer_headers(result_count)
    set_slimmer_headers(
      result_count: result_count,
      format:       "search",
      section:      "search",
      proposition:  "citizen"
    )
  end

  def setup_slimmer_artefact
    set_slimmer_dummy_artefact(:section_name => "Search", :section_link => "/search")
  end
end
