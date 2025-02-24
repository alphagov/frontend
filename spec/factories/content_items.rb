FactoryBot.define do
  factory :content_item do
    initialize_with { new(attributes.deep_stringify_keys) }
  end
end
