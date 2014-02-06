require "slimmer/headers"

class SearchController < ApplicationController

  before_filter :setup_slimmer_artefact, only: [:index]
  before_filter :set_expiry
  helper_method :ministerial_departments, :other_organisations, :closed_organisations, :selected_tab

  rescue_from GdsApi::BaseError, with: :error_503

  def index
    @search_term = params[:q]

    if @search_term.blank?
      render action: 'no_search_term' and return
    else
      search_params = {
        "organisation_slug" => params[:organisation],
        "sort" => params[:sort]
      }
      search_params.reject! { |k, v| v.blank? }
      search_response = search_client.search(@search_term, search_params)

      if search_response["spelling_suggestions"]
        @spelling_suggestion = search_response["spelling_suggestions"].first
      end

      # This is the total number of results displayed on the page, not the
      # total number of available results, hence counting up the result streams
      # rather than taking their "total" attributes
      @result_count = search_response["streams"].values.sum { |s| s["results"].count }

      response_streams = search_response["streams"].except("top-results")
      @streams = response_streams.map { |stream_key, stream_data|
        key_id = case stream_key
                 when "departments-policy"
                   "government"
                 else
                   stream_key
                 end
        SearchStream.new(
          key_id,
          stream_data["title"],
          stream_data["results"].map { |r| result_class(stream_key).new(r) }
        )
      }

      top_result_stream = search_response["streams"]["top-results"]
      @top_results = top_result_stream["results"].map { |r| GovernmentResult.new(r) }
    end

    fill_in_slimmer_headers(@result_count)

    @active_stream = active_stream(@streams)

    # We want to show the tabs if there's a filter in place
    # because there might be results with the filter turned off, but you can't
    # do that if the filter-form/tabs aren't displayed
    if (@result_count == 0) && params[:organisation].blank?
      render action: 'no_results' and return
    end
  end

  protected

  def search_client
    Frontend.combined_search_client
  end

  def result_class(stream_key)
    case stream_key
    when "departments-policy"
      GovernmentResult
    else
      SearchResult
    end
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
    # This list would be more robust if it were built from the streams
    tabs =  %w{ government-results services-information-results }
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
