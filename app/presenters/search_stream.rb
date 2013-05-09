class SearchStream

  attr_reader :key, :title, :results, :recommended

  def initialize(key, title, results, recommended = [])
    @key = key
    @title = title
    @results = results
    @recommended = recommended
  end

  def total_size
    # The number of results, including recommended links
    @results.size + @recommended.size
  end

  def anything_to_show?
    total_size > 0
  end
end
