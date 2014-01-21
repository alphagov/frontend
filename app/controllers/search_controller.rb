require "slimmer/headers"

class SearchController < ApplicationController

  before_filter :setup_slimmer_artefact, only: [:index]
  before_filter :set_expiry
  helper_method :ministerial_departments, :other_organisations, :selected_tab

  rescue_from GdsApi::BaseError, with: :error_503

  def index
    @search_term = params[:q]

    if @search_term.blank?
      render action: 'no_search_term' and return
    else
      @streams = []

      if params[:organisation].present? || params[:sort].present?
        government_results = retrieve_government_results(@search_term, params[:organisation], params[:sort])
        unfiltered_government_results = retrieve_government_results(@search_term)
      else
        government_results = retrieve_government_results(@search_term)
        unfiltered_government_results = government_results
      end

      if raw_mainstream_results(@search_term)["spelling_suggestions"]
        @spelling_suggestion = raw_mainstream_results(@search_term)["spelling_suggestions"].first
      end

      detailed_results = retrieve_detailed_guidance_results(@search_term)
      # hackily downweight detailed results to prevent them swamping mainstream results
      adjusted_detailed_results = multiply_result_scores(detailed_results, 0.8)

      @streams << SearchStream.new(
        "services-information",
        "Services and information",
        merge_result_sets(retrieve_mainstream_results(@search_term), adjusted_detailed_results)
      )
      @streams << SearchStream.new(
        "government",
        "Departments and policy",
        government_results
      )

      # This needs to be done before top result extraction, otherwise the
      # result count needs to incorporate the top result size.
      @result_count = @streams.map { |s| s.results.size }.sum

      top_result_sets = @streams.reject { |s| s.key == "government" }.map(&:results)
      # Hackily downweight government results to stop them from swamping mainstream in top results
      top_result_sets << multiply_result_scores(unfiltered_government_results, 0.6)

      all_results_ordered = merge_result_sets(*top_result_sets)
      @top_results = all_results_ordered[0..2]
      @top_results.each do |result_to_remove|
        @streams.detect do |stream|
          stream.results.delete(result_to_remove)
        end
      end
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

  def raw_mainstream_results(term)
    @_raw_mainstream_results ||= begin
      Frontend.mainstream_search_client.search(term)
    end
  end

  def retrieve_mainstream_results(term)
    res = raw_mainstream_results(term)
    res["results"].map { |r| SearchResult.new(r) }
  end


  def retrieve_detailed_guidance_results(term)
    res = Frontend.detailed_guidance_search_client.search(term)
    res["results"].map { |r| SearchResult.new(r) }
  end

  def retrieve_government_results(term, organisation = nil, sort = nil)
    extra_parameters = {}
    extra_parameters[:organisation_slug] = organisation if organisation
    extra_parameters[:sort] = sort if sort.present?
    res = Frontend.government_search_client.search(term, extra_parameters)
    res["results"].map { |r| GovernmentResult.new(r) }
  end

  def merge_result_sets(*result_sets)
    # .sort_by(&:es_score) will return it back to front
    result_sets.flatten(1).sort_by(&:es_score).reverse
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

  MINISTERIAL_DEPARTMENT_TYPE = "Ministerial department"
  def ministerial_departments
    @_ministerial_departments ||= sorted_organisations.select do |organisation|
      organisation["organisation_type"] == MINISTERIAL_DEPARTMENT_TYPE
    end
  end

  def other_organisations
    @_other_organisations ||= sorted_organisations.reject do |organisation|
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
