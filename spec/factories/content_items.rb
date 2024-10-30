FactoryBot.define do
  factory :content_item do
    initialize_with { new(attributes.deep_stringify_keys) }

    trait :attachments do
      details do
        {
          attachments: [
            {
              accessible: false,
              attachment_type: "document",
              content_type: "text/csv",
              file_size: 123,
              filename: "data_one.csv",
              id: 12_345,
              preview_url: "https://www.asset.test.gov.uk/data_one.csv/preview",
              title: "Data One",
              url: "https://www.asset.test.gov.uk/data_one.csv",
            },
            {
              accessible: false,
              attachment_type: "document",
              content_type: "text/csv",
              file_size: 123,
              filename: "data_two.csv",
              id: 12_346,
              preview_url: "https://www.asset.test.gov.uk/data_two.csv/preview",
              title: "Data Two",
              url: "https://www.asset.test.gov.uk/data_two.csv",
            },
          ],
        }
      end
    end

    factory :content_item_with_data_attachments, traits: [:attachments]
  end
end
