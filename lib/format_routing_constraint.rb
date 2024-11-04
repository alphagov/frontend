class FormatRoutingConstraint
  def initialize(format)
    @format = format
  end

  def matches?(request)
    content_item = ContentItemLoader.load(key(request))
    content_item.is_a?(GdsApi::Response) && content_item["schema_name"] == @format
  end

private

  def key(request)
    "/#{request.params.fetch(:slug)}"
  end
end
