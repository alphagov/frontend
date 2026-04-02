require "govuk_content_item_loader/test_helpers"

RSpec.describe ContentItemLoader do
  include GovukConditionalContentItemLoaderTestHelpers
  include ContentStoreHelpers

  subject(:content_item_loader) { described_class.new(request) }

  before do
    allow(GovukConditionalContentItemLoader).to receive(:new).and_call_original
    stub_conditional_loader_returns_content_item_for_path("/my-random-item")
  end

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
    let(:base_path) { "/my-random-item" }
    let(:request) do
      instance_double(
        ActionDispatch::Request,
        path: base_path,
        env: {},
        params: {},
      )
    end

    it "caches calls to the content store" do
      content_item_loader.load("/my-random-item")
      content_item_loader.load("/my-random-item")

      expect(GovukConditionalContentItemLoader).to have_received(:new).once
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

      expect(GovukConditionalContentItemLoader).to have_received(:new).twice
    end

    context "when the path uses traversal tricks" do
      let(:base_path) { "/../my-missing-item" }

      it "returns (but does not raise) an InvalidUrl exception" do
        expect(content_item_loader.load("/../my-missing-item")).to be_a(GdsApi::InvalidUrl)
      end
    end

    context "with a missing content item" do
      let(:base_path) { "/my-missing-item" }

      before do
        stub_conditional_loader_does_not_return_content_item_for_path(base_path)
      end

      it "returns (but does not raise) the original exception" do
        expect(content_item_loader.load(base_path)).to be_a(GdsApi::HTTPErrorResponse)
      end
    end

    context "when the content item schema is not in Rails.application.config.graphql_allowed_schemas" do
      subject(:content_item_loader) { described_class.for_request(request) }

      context "with ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE=true" do
        before do
          ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = "true"
          stub_const("ContentItemLoaders::LocalFileLoader::LOCAL_ITEMS_PATH", "spec/fixtures/local-content-items")
          stub_conditional_loader_returns_content_item_for_path("/my-random-item", { "schema_name" => "guide" })
        end

        after do
          ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = nil
        end

        context "with a local JSON file" do
          let(:base_path) { "/my-json-item" }

          before do
            stub_conditional_loader_returns_content_item_for_path(base_path)
          end

          it "loads content from the JSON file instead of the content store" do
            response = content_item_loader.load("/my-json-item")

            expect(GovukConditionalContentItemLoader).not_to have_received(:new)
            expect(ContentItemFactory.build(response).schema_name).to eq("json_page")
          end
        end

        context "with a local YAML file" do
          let(:base_path) { "/my-yaml-item" }

          before do
            stub_conditional_loader_returns_content_item_for_path(base_path)
          end

          it "loads content from the YAML file instead of the content store" do
            response = content_item_loader.load("/my-yaml-item")

            expect(GovukConditionalContentItemLoader).not_to have_received(:new)
            expect(ContentItemFactory.build(response).schema_name).to eq("yaml_page")
          end
        end

        context "with no local file" do
          let(:base_path) { "/my-remote-item" }

          before do
            stub_conditional_loader_returns_content_item_for_path(base_path)
          end

          it "returns to loading from the content store" do
            content_item_loader.load("/my-remote-item")

            expect(GovukConditionalContentItemLoader).to have_received(:new).once
          end
        end
      end

      context "when asked to load /government/history" do
        let(:base_path) { "/government/history" }
        let(:redirect_path) { "/government/history/history-of-the-uk-government" }

        before do
          stub_conditional_loader_returns_content_item_for_path(redirect_path)
        end

        it "loads the content item from the redirected path" do
          content_item_loader.load(base_path)

          expect(GovukConditionalContentItemLoader).to have_received(:new).with(request: satisfy { |req| req.path == redirect_path })
        end
      end
    end
  end
end
