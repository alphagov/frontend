class FullPathFormatRoutingConstraint < FormatRoutingConstraint
private

  def key(request)
    request.path
  end
end
