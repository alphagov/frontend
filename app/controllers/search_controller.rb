require "slimmer/headers"

class SearchController < ApplicationController

  before_filter :setup_slimmer_artefact, only: [:index]
  before_filter :set_expiry
  before_filter :set_results_tab, only: [:index]

  rescue_from GdsApi::Rummager::SearchServiceError, with: :error_503

  def index
    @search_term = params[:q]

    if @search_term.blank?
      render action: 'no_search_term' and return
    else
      @streams = []

      recommended_link_results = grouped_mainstream_results[:recommended_link]

      if feature_enabled?("combine")
        detailed_results = retrieve_detailed_guidance_results(@search_term)
        @streams << SearchStream.new(
          "services-information",
          "Services, information and guidance",
          merge_result_sets(mainstream_results, detailed_results),
          recommended_link_results
        )
        @streams << SearchStream.new(
          "government",
          "Policies, departments and announcements",
          retrieve_government_results(@search_term)
        )
      else
        @streams << SearchStream.new(
          "mainstream",
          "General results",
          mainstream_results,
          recommended_link_results
        )
        @streams << SearchStream.new(
          "detailed",
          "Detailed guidance",
          retrieve_detailed_guidance_results(@search_term)
        )
        @streams << SearchStream.new(
          "government",
          "Inside Government",
          retrieve_government_results(@search_term)
        )
      end

      @result_count = @streams.map { |s| s.total_size }.sum
      if feature_enabled?("top_result")
        # Pull out the best (first) result from across all the streams.
        #
        # We need to explicitly exclude empty streams, because streams with
        # only recommended results in them will still be in the list.
        non_empty_streams = @streams.reject { |s| s.results.empty? }
        best_stream = non_empty_streams.max_by { |s| s.results.first.es_score }
        @top_result = best_stream.results.first if best_stream
      end

      # Don't display any streams (tabs) that are now empty
      @streams.select! { |stream| stream.anything_to_show? }
    end

    fill_in_slimmer_headers(@result_count)

    if @result_count == 0
      render action: 'no_results' and return
    end
  end

  protected

  def grouped_mainstream_results
    @_grouped_mainstream_results ||= begin
      results = retrieve_mainstream_results(@search_term)
      grouped_results = results.group_by do |result|
        if !result.respond_to?(:format)
          :everything_else
        else
          if result.format == 'recommended-link'
            :recommended_link
          elsif result.format == 'inside-government-link'
            :inside_government_link
          else
            :everything_else
          end
        end
      end
      grouped_results[:recommended_link] ||= []
      grouped_results[:inside_government_link] ||= []
      grouped_results[:everything_else] ||= []
      grouped_results
    end
  end

  def mainstream_results
    @mainstream_results = grouped_mainstream_results[:inside_government_link] + grouped_mainstream_results[:everything_else]
  end

  def retrieve_mainstream_results(term)
    res = Frontend.mainstream_search_client.search(term)
    res.map { |r| SearchResult.new(r) }
  end

  def retrieve_detailed_guidance_results(term)
    res = Frontend.detailed_guidance_search_client.search(term)
    res.map { |r| SearchResult.new(r) }
  end

  def retrieve_government_results(term)
    res = Frontend.government_search_client.search(term)
    res.map { |r| GovernmentResult.new(r) }
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

  def set_results_tab
    tabs =  %w{ government-results detailed-results mainstream-results }
    @results_tab = tabs.include?(params[:tab]) ? params[:tab] : nil
  end

  def feature_enabled?(feature_name)
    PROTOTYPE_FEATURES_ENABLED_BY_DEFAULT || params[feature_name].present?
  end
end
