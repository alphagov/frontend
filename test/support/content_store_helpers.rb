require "gds_api/test_helpers/content_store"

module ContentStoreHelpers
  include GdsApi::TestHelpers::ContentStore

  def content_store_has_random_item(base_path:)
    example_generator = GovukSchemas::RandomExample.for_schema("placeholder", schema_type: "frontend")
    content_item = example_generator.merge_and_validate(base_path: base_path)
    content_store_has_item(content_item['base_path'], content_item)
  end

  def content_api_and_content_store_have_page(slug, artefact = artefact_for_slug(slug))
    content_store_has_random_item(base_path: "/#{slug}")
    content_api_has_an_artefact(slug, artefact)
  end

  def content_api_and_content_store_does_not_have_page(slug)
    content_api_does_not_have_an_artefact(slug)
    content_store_does_not_have_item("/#{slug}")
  end

  def content_api_and_content_store_have_unpublished_page(slug, edition, artefact = artefact_for_slug(slug))
    content_store_has_random_item(base_path: "/#{slug}")
    content_api_has_unpublished_artefact(slug, edition, artefact)
  end

  def content_store_throws_exception_for(path, exception)
    Services.content_store.stubs(:content_item).with(path).raises(exception)
  end

  def content_api_and_content_store_have_archived_page(slug)
    content_store_has_gone_item("/#{slug}")
    content_api_has_an_archived_artefact(slug)
  end

  def content_api_and_content_store_have_page_with_snac_code(slug, snac, artefact = artefact_for_slug(slug))
    content_store_has_random_item(base_path: "/#{slug}")
    content_api_has_an_artefact_with_snac_code(slug, snac, artefact)
  end
end
