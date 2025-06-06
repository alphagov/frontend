RSpec.describe "CsvPreviewRedirect" do
  include AssetManagerHelpers

  let(:filename) { "filename" }
  let(:asset_manager_id) { 4321 }
  let(:asset_media_url_path) { "media/#{asset_manager_id}/#{filename}.csv" }
  let(:parent_document_base_path) { "/government/important-guidance" }
  let(:parent_document_url) { "https://www.test.gov.uk#{parent_document_base_path}" }

  before do
    setup_asset_manager(parent_document_url, asset_manager_id, filename)
    setup_content_item(asset_media_url_path, parent_document_base_path)
  end

  # context "when the asset is draft and served from draft asset host" do
  #   before do
  #     asset_manager_response = { id: "https://asset-manager.dev.gov.uk/assets/foo", parent_document_url:, draft: true }
  #     stub_asset_manager_has_an_asset(asset_manager_id, asset_manager_response, "/#{filename}.csv")
  #     visit "http://draft-assets.dev.gov.uk/#{asset_media_url_path}/preview"
  #   end

  #   it "redirects to the csv-preview url with draft origin host" do
  #     expect(current_url).to eq("http://draft-origin.dev.gov.uk/csv-preview/#{asset_manager_id}/#{filename}.csv")
  #   end
  # end

  context "when the asset is live and served from asset host" do
    before do
      asset_manager_response = { id: "https://asset-manager.dev.gov.uk/assets/foo", parent_document_url: }
      stub_asset_manager_has_an_asset(asset_manager_id, asset_manager_response, "/#{filename}.csv")
      visit "http://assets.dev.gov.uk/#{asset_media_url_path}/preview"
    end

    it "redirects to the csv-preview url with origin host" do
      expect(current_url).to eq("http://www.dev.gov.uk/csv-preview/#{asset_manager_id}/#{filename}.csv")
    end
  end
end
