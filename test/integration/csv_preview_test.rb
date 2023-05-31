require "integration_test_helper"
require "gds_api/test_helpers/asset_manager"

class CsvPreviewTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::AssetManager

  attachment_id = 1234
  filename = "filename"
  legacy_url_path = "government/uploads/system/uploads/attachment_data/file/#{attachment_id}/#{filename}.csv"
  parent_document_url = "https://www.gov.uk/government/important-guidance"

  setup do
    asset_manager_response = {
      id: "https://asset-manager.dev.gov.uk/assets/foo",
      parent_document_url:,
    }
    stub_asset_manager_has_a_whitehall_asset(legacy_url_path, asset_manager_response)
  end

  context "when visiting the preview" do
    setup do
      visit "/#{legacy_url_path}/preview"
    end

    should "return a 200 response" do
      assert_equal 200, page.status_code
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
