class ContentFormatInspector
  include ActiveSupport::Rescuable

  attr_reader :error

  def initialize(slug)
    @slug = slug
  end

  def format
    content_item["schema_name"]
  end

private

  attr_reader :slug

  def handle_api_errors
    yield
  rescue GdsApi::HTTPErrorResponse,
         GdsApi::InvalidUrl => e
    @error = e
    {}
  end

  def content_item
    return {} if error?

    @content_item ||= handle_api_errors do
      CachedContentItem.fetch("/#{slug}")
    end
  end

  def error?
    @error.present?
  end
end
