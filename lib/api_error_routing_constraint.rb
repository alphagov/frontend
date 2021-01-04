class ApiErrorRoutingConstraint
  def matches?(request)
    request.env[:content_item_error].present?
  end
end
