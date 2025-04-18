require "gds_api/test_helpers/asset_manager"

module AssetManagerHelpers
  include GdsApi::TestHelpers::AssetManager

  def setup_asset_manager(parent_document_url, asset_manager_id, filename = nil, malformed: false, nonconvertible: false, asset_deleted: false, media_code: 200)
    asset_manager_response = { id: "https://asset-manager.dev.gov.uk/assets/foo", parent_document_url:, deleted: asset_deleted }
    stub_asset_manager_has_an_asset(asset_manager_id, asset_manager_response, filename)
    csv_file = if malformed
                 " \"Field 1\"\n"
               elsif nonconvertible
                 "\x8D\n"
               else
                 generate_test_csv(51, 1010)
               end
    stub_request(:get, "#{Plek.find('asset-manager')}/media/#{asset_manager_id}/#{filename}.csv").to_return(body: csv_file, status: media_code)
  end

  def setup_content_item(non_legacy_url_path, parent_document_base_path, content_type: "text/csv")
    filename = non_legacy_url_path.split("/").last
    content_item = {
      base_path: parent_document_base_path,
      document_type: "guidance",
      public_updated_at: "2023-05-27T08:00:07.000+00:00",
      phase: "live",
      details: {
        attachments: [
          { title: "Attachment 1", content_type: "text/csv", filename: "file.csv", url: "https://www.gov.uk/media/5678/file.csv", file_size: "1024" },
          { title: "Attachment 2", content_type:, filename:, url: "https://www.gov.uk/#{non_legacy_url_path}", file_size: "2048" },
        ],
      },
      links: {
        organisations: [
          {
            base_path: "/government/organisations/department-of-publishing",
            details: {
              brand: "single-identity",
              logo: {
                crest: "single-identity",
                formatted_title: "Department of Publishing",
              },
            },
          },
        ],
      },
    }
    stub_content_store_has_item(parent_document_base_path, content_item)
  end

  def generate_test_csv(column_count, row_count)
    csv_headers = CSV.generate_line((1..column_count).map { |column_number| "field_#{column_number}" })
    csv_row = CSV.generate_line((1..column_count).map { |column_number| "Value#{column_number}" })
    csv_rows = (1..row_count).map { |_| csv_row }
    ([csv_headers] + csv_rows).join("")
  end
end
