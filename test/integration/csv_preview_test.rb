require "integration_test_helper"
require "gds_api/test_helpers/asset_manager"
require "gds_api/test_helpers/content_store"

class CsvPreviewTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::AssetManager
  include GdsApi::TestHelpers::ContentStore

  attachment_id = 1234
  filename = "filename"
  legacy_url_path = "government/uploads/system/uploads/attachment_data/file/#{attachment_id}/#{filename}.csv"
  parent_document_base_path = "/government/important-guidance"
  parent_document_url = "https://www.gov.uk#{parent_document_base_path}"

  setup do
    asset_manager_response = {
      id: "https://asset-manager.dev.gov.uk/assets/foo",
      parent_document_url:,
    }
    stub_asset_manager_has_a_whitehall_asset(legacy_url_path, asset_manager_response)

    content_item = {
      base_path: parent_document_base_path,
      details: {
        attachments: [
          {
            title: "Attachment 1",
            url: "https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/5678/filename.csv",
          },
          {
            title: "Attachment 2",
            url: "https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/#{attachment_id}/#{filename}.csv",
          },
        ],
      },
    }
    stub_content_store_has_item(parent_document_base_path, content_item)
  end

  context "when visiting the preview" do
    setup do
      visit "/#{legacy_url_path}/preview"
    end

    should "return a 200 response" do
      assert_equal 200, page.status_code
    end

    should "include a link to the parent document" do
      assert page.has_link?("See more information about this guidance", href: parent_document_url)
    end

    should "include the correct asset title from the content item" do
      assert page.has_text?("Attachment 2")
    end
  end

  context "when the asset does not exist" do
    setup do
      stub_asset_manager_does_not_have_a_whitehall_asset("government/uploads/system/uploads/attachment_data/file/#{attachment_id}/#{filename}-2.csv")
      visit "/government/uploads/system/uploads/attachment_data/file/#{attachment_id}/#{filename}-2.csv/preview"
    end

    should "return a 404 response" do
      assert_equal 404, page.status_code
    end
  end
end
