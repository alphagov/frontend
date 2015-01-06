class SearchResultsPresenter
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper
  include Rails.application.routes.url_helpers

  def initialize(search_response, search_parameters)
    @search_response = search_response
    @search_parameters = search_parameters
  end

  def to_hash
    {
      query: search_parameters.search_term,
      result_count: result_count,
      result_count_string: result_count_string,
      results_any?: results.any?,
      results: results.map { |result| result.to_hash },
      filter_fields: filter_fields,
      debug_score: search_parameters.debug_score,
      has_next_page?: has_next_page?,
      has_previous_page?: has_previous_page?,
      next_page_link: next_page_link,
      next_page_label: next_page_label,
      previous_page_link: previous_page_link,
      previous_page_label: previous_page_label,
      first_result_number: (search_parameters.start + 1),
    }
  end

  def filter_fields
    filters = search_response["facets"].map do |field, value|
      facet_params = search_parameters.filter(field)
      facet = SearchFacetPresenter.new(value, facet_params)
      [field, facet.to_hash]
    end
    Hash[filters]
  end

  def spelling_suggestion
    if search_response["suggested_queries"]
      search_response["suggested_queries"].first
    end
  end

  def result_count
    search_response["total"].to_i
  end

  def result_count_string
    pluralize(number_with_delimiter(result_count), "result")
  end

  def results
    search_response["results"].map do |result|
      if result["index"] == "government"
        GovernmentResult.new(search_parameters, result)
      else
        SearchResult.new(search_parameters, result)
      end
    end
  end

  def has_next_page?
    (search_parameters.start +
     search_parameters.count) < result_count
  end

  def has_previous_page?
    search_parameters.start > 0
  end

  def next_page_link
    if has_next_page?
      search_parameters.build_link(start: next_page_start)
    end
  end

  def previous_page_link
    if has_previous_page?
      search_parameters.build_link(start: previous_page_start)
    end
  end

  def next_page_label
    if has_next_page?
      "#{next_page_number} of #{total_pages}"
    end
  end

  def previous_page_label
    if has_previous_page?
      "#{previous_page_number} of #{total_pages}"
    end
  end

private

  attr_reader :search_parameters, :search_response

  def next_page_start
    if has_next_page?
      search_parameters.start + search_parameters.count
    end
  end

  def previous_page_start
    if has_previous_page?
      start_at = search_parameters.start - search_parameters.count
      start_at < 0 ? 0 : start_at
    end
  end

  def total_pages
    # when count is zero, there would only ever be one page of results
    return 1 if search_parameters.count == 0

    (result_count.to_f / search_parameters.count.to_f).ceil
  end

  def current_page_number
    # if start is zero, then we must be on the first page
    return 1 if search_parameters.start == 0

    # eg. when start = 50 and count = 10:
    #          (50 / 10) + 1 = page 6
    (search_parameters.start.to_f / search_parameters.count.to_f).ceil + 1
  end

  def next_page_number
    current_page_number + 1
  end

  def previous_page_number
    current_page_number - 1
  end
end
