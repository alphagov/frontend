class ApiErrorRoutingConstraint
  def matches?(request)
    request.env[:__api_error].present?
  end
end
