class FormatRoutingConstraint
  def initialize(format)
    @format = format
  end

  def matches?(request)
    content_item = set_content_item(request)
    @format == content_item&.[]("schema_name")
  end

  def set_content_item(request)
    return request.env[:content_item] if already_cached?(request)

    slug = request.params.fetch(:slug)

    begin
      request.env[:content_item] = GdsApi.content_store.content_item("/#{slug}")
    rescue GdsApi::HTTPErrorResponse, GdsApi::InvalidUrl => e
      request.env[:content_item_error] = e
      nil
    end
  end

  def already_cached?(request)
    request.env.include?(:content_item) || request.env.include?(:content_item_error)
  end
end
