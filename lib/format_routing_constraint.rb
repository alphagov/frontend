class FormatRoutingConstraint
  def initialize(format, content_format_inspector: ContentFormatInspector)
    @format = format
    @content_format_inspector = content_format_inspector
  end

  def matches?(request)
    @request = request
    content_format == @format
  end

private

  def content_format
    @request.env[:__content_format] ||= begin
      format_inspector.format || set_error(format_inspector.error) || :no_match
    end
  end

  def set_error(err)
    @request.env[:__api_error] = err
    false
  end

  def format_inspector
    @request.env[:__inspector] ||= @content_format_inspector.new(slug)
  end

  def slug
    @request.params.fetch(:slug)
  end
end
