require "gds_api/test_helpers/asset_manager"

RSpec.describe "CsvPreview" do
  include AssetManagerHelpers

  let(:asset_manager_id) { 4321 }
  let(:parent_document_base_path) { "/government/important-guidance" }
  let(:parent_document_url) { "https://www.test.gov.uk#{parent_document_base_path}" }
  let(:asset_manager_filename) { "2023-01-10_filename" }
  let(:content_store_filename) { "2023-01-11_filename" }

  context "when asset manager file name does not match content store file name" do
    before do
      setup_asset_manager(parent_document_url, asset_manager_id, asset_manager_filename)
      setup_content_item(path_from_filename(content_store_filename), parent_document_base_path)
    end

    it "redirects to parent" do
      get "/#{path_from_filename(asset_manager_filename)}/preview"

      expect(response).to redirect_to(parent_document_url)
    end
  end

  context "when the file type of the attachment is not text/csv" do
    before do
      setup_asset_manager(parent_document_url, asset_manager_id, asset_manager_filename)
      setup_content_item(path_from_filename(asset_manager_filename), parent_document_base_path, content_type: "application/pdf")
    end

    it "redirects to parent" do
      get "/#{path_from_filename(asset_manager_filename)}/preview"

      expect(response).to have_http_status(:not_found)
    end
  end

  def path_from_filename(base_name)
    "media/#{asset_manager_id}/#{base_name}.csv"
  end
end
