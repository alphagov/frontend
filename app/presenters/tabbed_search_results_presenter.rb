class TabbedSearchResultsPresenter

  def initialize(search_response)
    @search_response = search_response
  end

  def spelling_suggestion
    if search_response["spelling_suggestions"]
      search_response["spelling_suggestions"].first
    end
  end

  def result_count
    search_response["streams"].values.sum { |s| s["results"].count }
  end

  def streams
    response_streams.map { |stream_key, stream_data|
      SearchStream.new(
        stream_key,
        stream_data["title"],
        stream_data["results"].map { |r| result_class(stream_key).new(r) },
        stream_key == "departments-policy"
      )
    }
  end

  def top_results
    top_result_stream = search_response["streams"]["top-results"]
    top_result_stream["results"].map { |r| GovernmentResult.new(r) }
  end

  private

  attr_reader :search_response

  def result_class(stream_key)
    case stream_key
    when "departments-policy"
      GovernmentResult
    else
      SearchResult
    end
  end

  def response_streams
    search_response["streams"].except("top-results")
  end

end
