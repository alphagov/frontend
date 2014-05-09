class UnifiedSearchResultsPresenter
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  def initialize(search_response, query, debug)
    @search_response = search_response
    @query = query
    @debug = debug
  end

  def to_hash
    {
      query: query,
      result_count: result_count,
      result_count_string: pluralize(number_with_delimiter(result_count), "result"),
      results_any?: results.any?,
      results: results.map { |result| result.to_hash }
    }
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
