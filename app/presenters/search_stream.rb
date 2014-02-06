class SearchStream

  attr_reader :key, :title, :results, :show_filter

  def initialize(key, title, results, show_filter = false)
    @key = key
    @title = title
    @results = results
    @show_filter = show_filter
  end

  def anything_to_show?
    @results.size > 0
  end
end
