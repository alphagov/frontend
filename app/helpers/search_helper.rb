module SearchHelper
  def capped_search_set_size
    [@results.count, @max_results].min
  end
end
