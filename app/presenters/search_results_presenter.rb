class SearchResultsPresenter
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  def initialize(search_response, query, params)
    @search_response = search_response
    @query = query
    @debug = params[:debug_score]
    @params = params
  end

  def to_hash
    {
      query: query,
      result_count: result_count,
      result_count_string: pluralize(number_with_delimiter(result_count), "result"),
      results_any?: results.any?,
      results: results.map { |result| result.to_hash },
      filter_fields: filter_fields,
      debug: @debug,
    }
  end

  def filter_fields
    filters = search_response["facets"].map do |key, value|
      facet_params = @params["filter_#{key.pluralize}"] || []
      facet = SearchFacetPresenter.new(value, facet_params)
      [key, facet.to_hash]
    end
    Hash[filters]
  end

  def spelling_suggestion
    if search_response["suggested_queries"]
      search_response["suggested_queries"].first
    end
  end

  def result_count
    search_response["total"]
  end

  def results
    search_response["results"].map do |result|
      if result["index"] == "government"
        GovernmentResult.new(result, debug)
      else
        SearchResult.new(result, debug)
      end
    end
  end

  private

  attr_reader :search_response, :debug, :query

end
