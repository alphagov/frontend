class ContentFormatInspector
  include ActiveSupport::Rescuable

  attr_reader :error

  def initialize(slug)
    @slug = slug
  end

  def format
    content_item['schema_name']
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
    @_content_item ||= handle_api_errors do
      content_store.content_item("/#{slug}")
    end
  end

  def error?
    @error.present?
  end

  def content_store
    @_content_store ||= Services.content_store
  end
end
