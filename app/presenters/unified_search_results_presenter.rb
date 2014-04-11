class UnifiedSearchResultsPresenter

  def initialize(search_response)
    @search_response = search_response
  end

  def spelling_suggestion
    if search_response["spelling_suggestions"]
      search_response["spelling_suggestions"].first
    end
  end

  def result_count
    search_response["total"]
  end

  def results
    search_response["results"].map do |result|
      if result["index"] == "government"
        GovernmentResult.new(result)
      else
        SearchResult.new(result)
      end
    end
  end

  private

  attr_reader :search_response

end
