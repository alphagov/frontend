class Webchat < ContentItem
  attr_reader :availability_url, :open_url, :redirect_attribute

  def initialize(content_store_response)
    super

    @availability_url = "https://d1y02qp19gjy8q.cloudfront.net/availability/18555309"
    @open_url = "https://d1y02qp19gjy8q.cloudfront.net/open/index.html"
    @redirect_attribute = "false"
  end
end
