class SearchResultsPresenter
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper
  include Rails.application.routes.url_helpers

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
      has_next_page?: has_next_page?,
      has_previous_page?: has_previous_page?,
      next_page_link: next_page_link,
      next_page_label: next_page_label,
      previous_page_link: previous_page_link,
      previous_page_label: previous_page_label,
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
    search_response["total"].to_i
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

  def has_next_page?
    requested_start >= 0 &&
      requested_count >= 0 &&
      (requested_start + requested_count) < result_count
  end

  def has_previous_page?
    requested_start > 0 &&
      requested_count >= 0
  end

  def next_page_link
    if has_next_page?
      search_path(search_parameters(start: next_page_start))
    end
  end

  def previous_page_link
    if has_previous_page?
      search_path(search_parameters(start: previous_page_start))
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

  attr_reader :search_response, :debug, :query, :params

  def requested_count
    params[:count].to_i
  end

  def requested_start
    params[:start].to_i
  end

  def next_page_start
    if has_next_page?
      requested_start + requested_count
    end
  end

  def previous_page_start
    if has_previous_page?
      start_at = requested_start - requested_count
      start_at < 0 ? 0 : start_at
    end
  end

  def total_pages
    # when count is zero, there would only ever be one page of results
    return 1 if requested_count == 0

    (result_count.to_f / requested_count.to_f).ceil
  end

  def current_page_number
    # if start is zero, then we must be on the first page
    return 1 if requested_start == 0

    (requested_start.to_f / requested_count.to_f).ceil + 1
  end

  def next_page_number
    current_page_number + 1
  end

  def previous_page_number
    current_page_number - 1
  end

  def custom_count_value?
    requested_count != 0 &&
      requested_count != SearchController::DEFAULT_RESULTS_PER_PAGE
  end

  def search_parameters(extra = {})
    # explicitly set the format to nil so that the path does not point to
    # /search.json
    combined_params = params.merge(format: nil)

    # don't include the 'count' query parameter unless we are overriding the
    # default value with a custom value
    unless custom_count_value?
      combined_params.delete(:count)
    end

    combined_params.merge(extra)
  end

end
