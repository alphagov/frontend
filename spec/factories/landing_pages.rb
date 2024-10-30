FactoryBot.define do
  factory :landing_page, class: LandingPage, parent: :content_item do
    base_path { "/landing-page/test" }
    schema_name { "landing_page" }
    details { { blocks: [] } }

    initialize_with { new(attributes.deep_stringify_keys) }

    factory :landing_page_with_one_block do
      details { { blocks: [{ type: "govspeak", content: "Hi There!" }] } }
    end

    factory :landing_page_with_data_attachments, traits: [:attachments]
  end
end
