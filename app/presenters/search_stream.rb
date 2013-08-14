class SearchStream

  attr_reader :key, :title, :results

  def initialize(key, title, results)
    @key = key
    @title = title
    @results = results
  end

  def anything_to_show?
    @results.size > 0
  end
end
