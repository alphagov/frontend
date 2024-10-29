FactoryBot.define do
  factory :landing_page do
    base_path { "/landing-page/test" }
    details { { blocks: [] } }

    initialize_with { new(attributes.deep_stringify_keys) }
  end
end
