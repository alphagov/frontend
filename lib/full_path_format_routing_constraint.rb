class FullPathFormatRoutingConstraint < FormatRoutingConstraint
private

  def already_cached?(_request)
    false
  end

  def key(request)
    request.path
  end
end
