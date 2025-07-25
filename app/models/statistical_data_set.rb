class StatisticalDataSet < ContentItem
  include Political
  include Updatable

  attr_reader :headers

  def initialize(content_store_response)
    super

    @headers = content_store_response.dig("details", "headers") || []
  end
end
