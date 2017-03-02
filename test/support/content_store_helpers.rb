require 'govuk_schemas'
require "gds_api/test_helpers/content_store"

module ContentStoreHelpers
  include GdsApi::TestHelpers::ContentStore

  def content_store_has_example_item_not_tagged_to_taxon(base_path, schema:, example: nil)
    content_item = GovukSchemas::Example.find(schema, example_name: example || schema)
    content_item['links']['taxons'] = []
    content_store_has_item(base_path, content_item)
    content_item
  end

  def basic_taxon
    {
      "content_id" => "30c1b93d-2553-47c9-bc3c-fc5b513ecc32",
      "locale" => "en",
      "title" => "A Taxon",
      "base_path" => "/a-taxon",
    }
  end

  def content_store_has_example_item_tagged_to_taxon(base_path, schema:, example: nil)
    content_item = GovukSchemas::Example.find(schema, example_name: example || schema)
    content_item["base_path"] = base_path
    content_item["links"] = { taxons: [basic_taxon] }

    content_store_has_item(base_path, content_item)
    content_item
  end

  def content_store_has_random_item_not_tagged_to_taxon(base_path:, schema: 'placeholder')
    example_generator = GovukSchemas::RandomExample.for_schema(frontend_schema: schema)
    content_item = example_generator.merge_and_validate(
      base_path: base_path,
      links: { taxons: [] }
    )
    content_store_has_item(content_item['base_path'], content_item)
    content_item
  end

  def content_store_has_random_item_tagged_to_taxon(base_path:, schema: 'placeholder')
    example_generator = GovukSchemas::RandomExample.for_schema(frontend_schema: schema)
    content_item = example_generator.merge_and_validate(
      base_path: base_path,
      links: { taxons: [basic_taxon] }
    )
    content_store_has_item(content_item['base_path'], content_item)
  end

  def content_store_has_item_tagged_to_taxon(base_path:, payload:)
    content_item = payload.merge(
      base_path: base_path,
      links: { taxons: [basic_taxon] }
    )
    content_store_has_item(base_path, content_item)
  end

  def content_api_and_content_store_have_page(slug, artefact = artefact_for_slug(slug))
    content_store_has_random_item_not_tagged_to_taxon(base_path: "/#{slug}")
    content_api_has_an_artefact(slug, artefact)
  end

  def content_api_and_content_store_have_page_tagged_to_taxon(slug, artefact = artefact_for_slug(slug))
    content_store_has_random_item_tagged_to_taxon(base_path: "/#{slug}")
    content_api_has_an_artefact(slug, artefact)
  end

  def content_api_and_content_store_does_not_have_page(slug)
    content_api_does_not_have_an_artefact(slug)
    content_store_does_not_have_item("/#{slug}")
  end

  def content_api_and_content_store_have_unpublished_page(slug, edition, artefact = artefact_for_slug(slug))
    content_store_has_random_item_not_tagged_to_taxon(base_path: "/#{slug}")
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
    content_store_has_random_item_not_tagged_to_taxon(base_path: "/#{slug}")
    content_api_has_an_artefact_with_snac_code(slug, snac, artefact)
  end
end
