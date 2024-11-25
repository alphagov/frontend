class ApiErrorRoutingConstraint
  def matches?(request)
    ContentItemLoader.for_request(request).load(request.path).is_a?(StandardError)
  end
end
