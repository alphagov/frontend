class ContentFormatInspector
  include ActiveSupport::Rescuable

  attr_reader :error

  MIGRATED_SCHEMAS = %w(
    completed_transaction
    guide
    licence
    place
    local_transaction
    simple_smart_answer
    transaction
  ).freeze

  def initialize(slug, edition = nil)
    @slug = slug
    @edition = edition
  end

  def format
    if draft_requested? && artefact.present?
      artefact['format']
    elsif migrated? && content_item.present?
      content_item['schema_name']
    elsif artefact.present?
      artefact['format']
    end
  end

private

  attr_reader :slug, :edition

  def handle_api_errors
    yield
  rescue GdsApi::HTTPErrorResponse,
         GdsApi::InvalidUrl,
         ArtefactRetriever::RecordArchived,
         ArtefactRetriever::RecordNotFound => e
    @error = e
    {}
  end

  def draft_requested?
    edition.present?
  end

  def migrated?
    MIGRATED_SCHEMAS.include? content_item.to_h['schema_name']
  end

  def content_item
    return {} if error?
    @_content_item ||= handle_api_errors do
      content_store.content_item("/#{slug}")
    end
  end

  def artefact
    return {} if error?
    @_artefact ||= handle_api_errors do
      artefact_retriever.fetch_artefact(slug, edition)
    end
  end

  def error?
    @error.present?
  end

  def content_store
    @_content_store ||= Services.content_store
  end

  def artefact_retriever
    @_artefact_retriever ||= ArtefactRetrieverFactory.artefact_retriever
  end
end
