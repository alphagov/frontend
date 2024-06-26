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

  def stub_content_store_has_item_tagged_to_taxon(base_path:, payload:)
    content_item = payload.merge(
      base_path:,
      links: { taxons: [basic_taxon] },
    )
    stub_content_store_has_item(base_path, content_item)
  end

  def content_store_has_page(slug, schema: "generic", is_tagged_to_taxon: false)
    content_store_has_random_item(base_path: "/#{slug}", schema:, is_tagged_to_taxon:)
  end

  def content_store_does_not_have_page(slug)
    stub_content_store_does_not_have_item("/#{slug}")
  end

  def content_store_has_unpublished_page(slug)
    content_store_has_random_item(base_path: "/#{slug}")
  end

  def content_store_has_archived_page(slug)
    stub_content_store_has_gone_item("/#{slug}")
  end

  def honours_content_store_ttl
    assert_equal "max-age=#{15.minutes.to_i}, public", response.headers["Cache-Control"]
  end
end
