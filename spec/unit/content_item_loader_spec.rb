RSpec.describe ContentItemLoader do
  include ContentStoreHelpers

  let!(:item_request) { stub_content_store_has_item("/my-random-item") }

  describe ".load" do
    it "caches calls to the content store" do
      ContentItemLoader.load("/my-random-item")
      ContentItemLoader.load("/my-random-item")

      expect(item_request).to have_been_made.once
    end

    context "with a missing content item" do
      before do
        stub_content_store_does_not_have_item("/my-missing-item")
      end

      it "returns (but does not raise) the original exception" do
        expect(ContentItemLoader.load("/my-missing-item")).to be_a(GdsApi::HTTPErrorResponse)
      end
    end

    context "With ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE=true" do
      before do
        ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = "true"
        stub_const("ContentItemLoader::LOCAL_ITEMS_PATH", "spec/fixtures/local-content-items")
      end

      after do
        ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = nil
      end

      context "with a local JSON file" do
        let!(:item_request) { stub_content_store_has_item("/my-json-item") }

        it "loads content from the JSON file instead of the content store" do
          response = ContentItemLoader.load("/my-json-item")

          expect(item_request).not_to have_been_made
          expect(ContentItemFactory.build(response).schema_name).to eq("json_page")
        end
      end

      context "with a local YAML file" do
        let!(:item_request) { stub_content_store_has_item("/my-yaml-item") }

        it "loads content from the YAML file instead of the content store" do
          response = ContentItemLoader.load("/my-yaml-item")

          expect(item_request).not_to have_been_made
          expect(ContentItemFactory.build(response).schema_name).to eq("yaml_page")
        end
      end

      context "with no local file" do
        let!(:item_request) { stub_content_store_has_item("/my-remote-item") }

        it "returns to loading from the content store" do
          ContentItemLoader.load("/my-remote-item")

          expect(item_request).to have_been_made.once
        end
      end
    end
  end
end
