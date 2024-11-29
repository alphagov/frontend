module LandingPage::Block
  class DocumentList < Base
    attr_reader :taxon_base_path, :heading

    TAXON_SEARCH_FIELDS = %w[title
                             link
                             description
                             format
                             public_timestamp].freeze

    def initialize(block_hash, landing_page)
      super

      @taxon_base_path = data["taxon_base_path"]
      @heading = data["heading"]
    end

    def full_width?
      false
    end

    def items
      items_from_taxon.presence || explicitly_configured_items
    rescue StandardError
      []
    end

  private

    def items_from_taxon
      return [] if taxon_base_path.blank?
      return [] unless taxon_exists?

      taxon_search_results.map do |result|
        {
          link: {
            text: result["title"],
            path: result["link"],
          },
          metadata: {
            public_updated_at: Time.zone.parse(result["public_timestamp"]),
            document_type: result["format"].humanize,
          },
        }
      end
    end

    def taxon_exists?
      taxon_content_id.present?
    end

    def taxon_content_id
      @taxon_content_id ||= begin
        response = GdsApi.content_store.content_item(taxon_base_path)
        response["content_id"]
      end
    rescue GdsApi::ContentStore::ItemNotFound
      nil
    end

    def taxon_search_results
      params = {
        start: 0,
        count: 5,
        fields: TAXON_SEARCH_FIELDS,
        filter_part_of_taxonomy_tree: [taxon_content_id],
        order: "-public_timestamp",
      }

      results = GdsApi.search.search(params)
      results["results"]
    end

    def explicitly_configured_items
      data.fetch("items").map do |i|
        {
          link: {
            text: i["text"],
            path: i["path"],
          },
          metadata: {
            public_updated_at: Time.zone.parse(i["public_updated_at"]),
            document_type: i["document_type"],
          },
        }
      end
    end
  end
end
