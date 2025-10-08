class Webchat < ContentItem
  attr_reader :availability_url

  def initialize(content_store_response)
    super

    @availability_url = "https://d1y02qp19gjy8q.cloudfront.net/availability/18555309"
  end
end
