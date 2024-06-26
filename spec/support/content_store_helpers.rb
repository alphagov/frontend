require "govuk_schemas"
require "gds_api/test_helpers/content_store"

module ContentStoreHelpers
  include GdsApi::TestHelpers::ContentStore

  def basic_taxon
    {
      "content_id" => "30c1b93d-2553-47c9-bc3c-fc5b513ecc32",
      "locale" => "en",
      "title" => "A Taxon",
      "base_path" => "/a-taxon",
    }
  end

  def content_store_has_random_item(base_path:, schema: "generic", is_tagged_to_taxon: false, details: {})
    content_item = GovukSchemas::RandomExample.for_schema(frontend_schema: schema) do |item|
      taxons = is_tagged_to_taxon ? [basic_taxon] : []
      item.merge!(
        "base_path" => base_path,
        "links" => { "taxons" => taxons },
      )
      item["details"].merge!(details)
      item
    end

    stub_content_store_has_item(content_item["base_path"], content_item)
    content_item
  end

  def content_store_throws_exception_for(path, exception)
    content_store = double
    allow(content_store).to receive(:content_item).with(path).and_raise(exception)
    allow(GdsApi).to receive(:content_store).and_return(content_store)
  end
end
