class ScopedSearchResultsPresenter < SearchResultsPresenter

  def to_hash
    super.merge({
      is_scoped?: true,
      scope_title: scope_title,
      unscoped_results_any?: unscoped_results.any?,
      unscoped_result_count: result_count_string(unscoped_result_count),
    })
  end

private

  attr_reader :unscoped_results

  def filter_fields
    []
  end

  def scope_title
    search_response["scope"]["title"]
  end

  def results
    result_list = search_response["results"].map { |result| build_scoped_result(result).to_hash }

    if unscoped_results.any?
      insertion_point = [result_list.count, 3].min
      unscoped_results_sublist = { results: unscoped_results, is_multiple_results: true }

      result_list.insert(insertion_point, unscoped_results_sublist)
    end
    result_list
  end

  def unscoped_result_count
    search_response["unscoped_results"]["total"]
  end

  def unscoped_results
    @unscoped_results ||= build_result_presenters

  end

  def build_result_presenters
    search_response["unscoped_results"]["results"].map { |result| build_result(result).to_hash }
  end

  def build_scoped_result(result)
    ScopedResult.new(search_parameters, result)
  end

end
