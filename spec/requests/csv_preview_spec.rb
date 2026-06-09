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
      get "/csv-preview/#{asset_manager_id}/#{asset_manager_filename}.csv"

      expect(response).to redirect_to(parent_document_url)
    end
  end

  context "when the file type of the attachment is not text/csv" do
    before do
      setup_asset_manager(parent_document_url, asset_manager_id, asset_manager_filename)
      setup_content_item(path_from_filename(asset_manager_filename), parent_document_base_path, content_type: "application/pdf")
    end

    it "redirects to parent" do
      get "/csv-preview/#{asset_manager_id}/#{asset_manager_filename}.csv"

      expect(response).to have_http_status(:not_found)
    end
  end

  context "when the parent item does not contain attachment info" do
    before do
      setup_asset_manager(parent_document_url, asset_manager_id, asset_manager_filename)
      stub_conditional_loader_returns_content_item_for_path(parent_document_base_path, {})
    end

    it "returns 404" do
      get "/csv-preview/#{asset_manager_id}/#{asset_manager_filename}.csv"

      expect(response).to have_http_status(404)
    end

    context "when the parent item is a redirect" do
      before do
        setup_redirect_content_item("/redirected", parent_document_base_path)
        setup_content_item(path_from_filename(asset_manager_filename), parent_document_base_path)
      end

      it "follows the redirect and returns 200" do
        get "/csv-preview/#{asset_manager_id}/#{asset_manager_filename}.csv"

        expect(response).to have_http_status(200)
      end

      context "when it redirects more than 5 times" do
        before do
          setup_redirect_content_item(parent_document_base_path, parent_document_base_path)
        end

        it "returns 404 and records the problem in Sentry" do
          expect(GovukError).to receive(:notify)

          get "/csv-preview/#{asset_manager_id}/#{asset_manager_filename}.csv"

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  def path_from_filename(base_name)
    "media/#{asset_manager_id}/#{base_name}.csv"
  end
end
