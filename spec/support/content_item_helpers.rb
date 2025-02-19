module ContentItemHelpers
  def content_item_from_factory(content_item_hash:)
    http_response = instance_double(RestClient::Response, body: content_item_hash.to_json)

    ContentItemFactory.build(GdsApi::Response.new(http_response))
  end
end
