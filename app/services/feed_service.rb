class FeedService
  DEFAULT_FEED_FIELDS = %w[
    display_type
    title
    link
    public_timestamp
    format
    content_store_document_type
    description
    content_id
    organisations
    document_collections
  ].freeze

  DEFAULT_SEARCH_OPTIONS = {
    count: 5,
    order: "-public_timestamp",
    fields: DEFAULT_FEED_FIELDS,
  }.freeze

  def initialize(search_options: {})
    @search_options = DEFAULT_SEARCH_OPTIONS.merge(search_options)
  end

  def fetch_related_documents_with_format
    search_response = GdsApi.search.search(@search_options)
    format_results(search_response)
  end

private

  def display_type(document)
    key = document.fetch("display_type", nil) || document.fetch("content_store_document_type", "")
    key.humanize
  end

  def format_results(search_response)
    search_response["results"].map do |document|
      {
        link: {
          text: document["title"],
          path: document["link"],
        },
        metadata: {
          public_updated_at: document["public_timestamp"],
          document_type: display_type(document),
        },
      }
    end
  end
end
