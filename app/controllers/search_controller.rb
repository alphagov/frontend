require "slimmer/headers"

class SearchController < ApplicationController
  before_filter :setup_slimmer_artefact, only: [:index]
  before_filter :set_expiry

  def index
    @search_term = params[:q]

    if @search_term.blank?
      render action: 'no_search_term' and return
    end

    if @search_term.present?
      @external_link_results, @mainstream_results = extract_external_links(retrieve_mainstream_results(@search_term))
      @detailed_guidance_results = retrieve_detailed_guidance_results(@search_term)
      if include_government_results?
        @government_results = retrieve_government_results(@search_term)
      else
        @government_results = []
      end

      @all_results = @mainstream_results + @detailed_guidance_results + @government_results + @external_link_results
      @count_results = @mainstream_results + @detailed_guidance_results + @government_results
    end

    fill_in_slimmer_headers(@all_results)

    if @all_results.empty?
      render action: 'no_results' and return
    end
  rescue GdsApi::Rummager::SearchServiceError
    error_503 and return
  end

  protected

  def retrieve_mainstream_results(term)
    res = Frontend.mainstream_search_client.search(term)
    res.map { |r| SearchResult.new(r) }
  end

  def extract_external_links(results)
    results.partition do |result|
      (result.respond_to?(:format) && result.format == 'recommended-link')
    end
  end

  def retrieve_detailed_guidance_results(term)
    res = Frontend.detailed_guidance_search_client.search(term)
    res.map { |r| SearchResult.new(r) }
  end

  def retrieve_government_results(term)
    res = Frontend.government_search_client.search(term)
    res.map { |r| SearchResult.new(r) }
  end

  def fill_in_slimmer_headers(result_set)
    set_slimmer_headers(
      result_count: result_set.length,
      format:       "search",
      section:      "search",
      proposition:  "citizen"
    )
  end

  def setup_slimmer_artefact
    set_slimmer_dummy_artefact(:section_name => "Search", :section_link => "/search")
  end

  def include_government_results?
    params[:government].present?
  end
end
