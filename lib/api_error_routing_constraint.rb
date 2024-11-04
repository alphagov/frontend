class ApiErrorRoutingConstraint
  def matches?(request)
    ContentItemLoader.load(request.path).is_a?(StandardError)
  end
end
