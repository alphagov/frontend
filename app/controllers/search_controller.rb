require "slimmer/headers"

class SearchController < ApplicationController

  before_filter :setup_slimmer_artefact, only: [:index, :unified]
  before_filter :set_expiry
  helper_method :ministerial_departments, :other_organisations, :closed_organisations, :selected_tab

  rescue_from GdsApi::BaseError, with: :error_503

  DEFAULT_RESULTS_PER_PAGE = 50
  MAX_RESULTS_PER_PAGE = 100

  def index
    @search_term = params[:q]

    if @search_term.blank?
      render action: 'no_search_term' and return
    end

    search_response = combined_search_client.search(@search_term, combined_search_params)
    results = TabbedSearchResultsPresenter.new(search_response)
    @spelling_suggestion = results.spelling_suggestion
    @result_count = results.result_count
    @streams = results.streams
    @top_results = results.top_results
    @active_stream = active_stream(@streams)

    fill_in_slimmer_headers(@result_count)

    # We want to show the tabs if there's a filter in place
    # because there might be results with the filter turned off, but you can't
    # do that if the filter-form/tabs aren't displayed
    if (@result_count == 0) && params[:organisation].blank?
      render action: 'no_results' and return
    end
  end

  def unified
    @ui = :unified
    @search_term = params[:q]
    if @search_term.blank?
      render action: 'no_search_term' and return
    end

    search_params = {
      start: params[:start],
      count: "#{requested_result_count}",
      q: @search_term,
      filter_organisations: [*params[:filter_organisations]],
      facet_organisations: "100",
    }
    search_response = search_client.unified_search(search_params)

    @results = UnifiedSearchResultsPresenter.new(search_response, @search_term, params)
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

  def combined_search_params
    {
      "organisation_slug" => params[:organisation],
      "sort" => params[:sort],
    }.reject { |_, v| v.blank? }
  end

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

  def combined_search_client
    Frontend.combined_search_client
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

  # The tab that the user has clicked on. We should remember this.
  def selected_tab
    # This list would be more robust if it were built from the streams,
    # but then it doesn't work if, say, there is no search term and we haven't
    # made a request to Rummager
    tabs = %w{ departments-policy-results services-information-results }
    tabs.include?(params[:tab]) ? params[:tab] : nil
  end

  # The tab that should be selected.
  # If the user has selected a tab, use that one.
  # Otherwise, select the first tab with results.
  # If there are no results, select the first tab.
  def active_stream(streams)
    active_stream = streams.detect do |stream|
      stream_key_as_tab_name = "#{stream.key}-results"
      if selected_tab
        stream_key_as_tab_name == selected_tab
      else
        stream.anything_to_show?
      end
    end
    active_stream || streams.first
  end

  def organisations
    @_organisations ||= Frontend.organisations_search_client.organisations["results"] || []
  end

  def sorted_organisations
    @_sorted_organisations ||= organisations.sort_by do |organisation|
      organisation["title"]
    end
  end

  CLOSED_ORGANISATION_STATE = "closed"
  def closed_organisations
    @_closed_organisations ||= sorted_organisations.select do |organisation|
      organisation["organisation_state"] == CLOSED_ORGANISATION_STATE
    end
  end

  def open_organisations
    @_open_organisations ||= sorted_organisations.reject do |organisation|
      organisation["organisation_state"] == CLOSED_ORGANISATION_STATE
    end
  end

  MINISTERIAL_DEPARTMENT_TYPE = "Ministerial department"
  def ministerial_departments
    @_ministerial_departments ||= open_organisations.select do |organisation|
      organisation["organisation_type"] == MINISTERIAL_DEPARTMENT_TYPE
    end
  end

  def other_organisations
    @_other_organisations ||= open_organisations.reject do |organisation|
      organisation["organisation_type"] == MINISTERIAL_DEPARTMENT_TYPE
    end
  end

  def multiply_result_scores(result_set, multiply_by)
    result_set.map do |result|
      result.result["es_score"] = result.result["es_score"] * multiply_by
      result
    end
  end
end
