FactoryBot.define do
  factory :landing_page, parent: :content_item do
    base_path { "/landing-page/test" }
    schema_name { "landing_page" }
    details { { blocks: [] } }

    initialize_with { new(attributes.deep_stringify_keys) }

    factory :landing_page_with_data_attachments, traits: [:attachments]
  end
end
