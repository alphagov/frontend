RSpec.describe ContentItemLoader do
  include ContentStoreHelpers

  subject(:content_item_loader) { described_class.new }

  let!(:item_request) { stub_content_store_has_item("/my-random-item") }

  describe ".for_request" do
    it "returns a new object per request" do
      request_1 = instance_double(ActionDispatch::Request, path: "/my-random-item", env: {}, params: {})
      request_2 = instance_double(ActionDispatch::Request, path: "/my-random-item", env: {})

      loader_1 = described_class.for_request(request_1)
      loader_2 = described_class.for_request(request_2)

      expect(loader_1).not_to eq(loader_2)
    end

    it "returns the same object for the same request" do
      request_1 = instance_double(ActionDispatch::Request, path: "/my-random-item", env: {}, params: {})

      loader_1 = described_class.for_request(request_1)
      loader_2 = described_class.for_request(request_1)

      expect(loader_1).to eq(loader_2)
    end
  end

  describe "#load" do
    it "caches calls to the content store" do
      content_item_loader.load("/my-random-item")
      content_item_loader.load("/my-random-item")

      expect(item_request).to have_been_made.once
    end

    it "restricts cache to the specific instance of the class, so does not cache across requests" do
      request_1 = instance_double(
        ActionDispatch::Request,
        path: "/my-random-item",
        env: {},
        headers: {},
        params: { "graphql" => "false" },
      )
      request_2 = instance_double(
        ActionDispatch::Request,
        path: "/my-random-item",
        env: {},
        headers: {},
        params: { "graphql" => "false" },
      )

      loader_1 = described_class.for_request(request_1)
      loader_2 = described_class.for_request(request_2)

      loader_1.load(request_1.path)
      loader_2.load(request_2.path)

      expect(item_request).to have_been_made.twice
    end

    context "when the path uses traversal tricks" do
      it "returns (but does not raise) an InvalidUrl exception" do
        expect(content_item_loader.load("/../my-missing-item")).to be_a(GdsApi::InvalidUrl)
      end
    end

    context "with a missing content item" do
      before do
        stub_content_store_does_not_have_item("/my-missing-item")
      end

      it "returns (but does not raise) the original exception" do
        expect(content_item_loader.load("/my-missing-item")).to be_a(GdsApi::HTTPErrorResponse)
      end
    end

    context "with ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE=true" do
      subject(:content_item_loader) { described_class.new }

      before do
        ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = "true"
        stub_const("ContentItemLoaders::LocalFileLoader::LOCAL_ITEMS_PATH", "spec/fixtures/local-content-items")
      end

      after do
        ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = nil
      end

      context "with a local JSON file" do
        let!(:item_request) { stub_content_store_has_item("/my-json-item") }

        it "loads content from the JSON file instead of the content store" do
          response = content_item_loader.load("/my-json-item")

          expect(item_request).not_to have_been_made
          expect(ContentItemFactory.build(response).schema_name).to eq("json_page")
        end
      end

      context "with a local YAML file" do
        let!(:item_request) { stub_content_store_has_item("/my-yaml-item") }

        it "loads content from the YAML file instead of the content store" do
          response = content_item_loader.load("/my-yaml-item")

          expect(item_request).not_to have_been_made
          expect(ContentItemFactory.build(response).schema_name).to eq("yaml_page")
        end
      end

      context "with no local file" do
        let!(:item_request) { stub_content_store_has_item("/my-remote-item") }

        it "returns to loading from the content store" do
          content_item_loader.load("/my-remote-item")

          expect(item_request).to have_been_made.once
        end
      end
    end

    context "when asked to load /government/history" do
      let!(:item_request) { stub_content_store_has_item("/government/history/history-of-the-uk-government") }

      it "loads the content item from /government/history/history-of-the-uk-government" do
        content_item_loader.load("/government/history")

        expect(item_request).to have_been_made
      end
    end
  end
end
