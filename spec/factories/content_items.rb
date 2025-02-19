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
              preview_url: "https://ignored-asset-domain/media/000000000000000000000001/data_one.csv/preview",
              title: "Data One",
              url: "https://ignored-asset-domain/media/000000000000000000000001/data_one.csv",
            },
            {
              accessible: false,
              attachment_type: "document",
              content_type: "text/csv",
              file_size: 123,
              filename: "data_two.csv",
              id: 12_346,
              preview_url: "https://ignored-asset-domain/media/000000000000000000000002/data_two.csv/preview",
              title: "Data Two",
              url: "https://ignored-asset-domain/media/000000000000000000000002/data_two.csv",
            },
            {
              accessible: false,
              attachment_type: "document",
              content_type: "text/csv",
              file_size: 123,
              filename: "data_three.csv",
              id: 12_347,
              preview_url: "https://ignored-asset-domain/media/000000000000000000000003/data_three.csv/preview",
              title: "Data Three",
              url: "https://ignored-asset-domain/media/000000000000000000000003/data_three.csv",
            },
            {
              accessible: false,
              attachment_type: "document",
              content_type: "text/csv",
              file_size: 123,
              filename: "data_four.csv",
              id: 12_348,
              preview_url: "https://ignored-asset-domain/media/000000000000000000000004/data_four.csv/preview",
              title: "Data Four",
              url: "https://ignored-asset-domain/media/000000000000000000000004/data_four.csv",
            },
          ],
        }
      end
    end

    factory :content_item_with_data_attachments, traits: [:attachments]
  end
end
