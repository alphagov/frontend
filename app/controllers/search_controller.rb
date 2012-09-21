class SearchController < ApplicationController
  def index
    @max_results = 50

    @search_term = params[:q]

    if @search_term.blank?
      render action: 'no_search_term' and return
    end

    if @search_term.present?
      @results = retrieve_results(@search_term, @max_results, params["format_filter"])
      @secondary_results = @results.select { |r| r.format == 'specialist_guidance' }
    end

    fill_in_slimmer_headers(@results)

    if @results.empty?
      render action: 'no_results' and return
    end
  end

  protected
  def retrieve_results(term, limit = 50, format_filter = nil)
    res = Frontend.mainstream_search_client.search(term, format_filter).take(limit)
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
end
