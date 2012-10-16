require "slimmer/headers"

class SearchController < ApplicationController
  before_filter :setup_slimmer_artefact, only: [:index]
  before_filter :set_expiry

  def index
    @search_term = params[:q]

    if @search_term.blank?
      fill_in_slimmer_headers([])
      render action: 'no_search_term' and return
    end

    if @search_term.present?
      @external_link_results, @primary_results = extract_external_links(retrieve_primary_results(@search_term))
      @secondary_results = retrieve_secondary_results(@search_term)

      @all_results = @primary_results + @secondary_results + @external_link_results
      @count_results = @primary_results + @secondary_results
    end

    fill_in_slimmer_headers(@all_results)

    if @all_results.empty?
      render action: 'no_results' and return
    end
  rescue GdsApi::Rummager::SearchServiceError
    error_503 and return
  end

  protected

  def retrieve_primary_results(term)
    res = Frontend.mainstream_search_client.search(term)
    res.map { |r| SearchResult.new(r) }
  end

  def extract_external_links(results)
    results.partition do |result|
      (result.respond_to?(:format) && result.format == 'recommended-link')
    end
  end

  def retrieve_secondary_results(term)
    res = Frontend.detailed_guidance_search_client.search(term)
    res.map { |r| SearchResult.new(r) }
  end

  def fill_in_slimmer_headers(result_set)
    set_slimmer_headers(
      result_count: result_set.length,
      format:               "search",
      section:              "search",
      proposition:          "citizen",
      remove_meta_viewport: true,
    )
  end

  def setup_slimmer_artefact
    set_slimmer_dummy_artefact(:section_name => "Search", :section_link => "/search")
  end
end
