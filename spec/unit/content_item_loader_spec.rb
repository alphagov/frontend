require "gds_api/test_helpers/publishing_api"

RSpec.describe ContentItemLoader do
  include GdsApi::TestHelpers::PublishingApi
  include ContentStoreHelpers

  subject(:content_item_loader) { described_class.new }

  let!(:item_request) { stub_content_store_has_item("/my-random-item") }

  shared_examples "rendered from Content Store" do
    it "calls the Content Store only" do
      content_item_loader.load(request.path)

      expect(graphql_request).not_to have_been_made
      expect(item_request).to have_been_made
    end
  end

  shared_examples "rendered from Draft Content Store" do
    it "calls the Draft Content Store only" do
      ClimateControl.modify(PLEK_HOSTNAME_PREFIX: "draft-") do
        content_item_loader.load(request.path)

        expect(graphql_request).not_to have_been_made
        expect(item_request).to have_been_made
      end
    end
  end

  shared_examples "rendered from GraphQL" do
    it "calls the GraphQL endpoint in additon to Content Store" do
      content_item_loader.load(request.path)

      expect(item_request).to have_been_made
      expect(graphql_request).to have_been_made
    end
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

    context "with a missing content item" do
      before do
        stub_content_store_does_not_have_item("/my-missing-item")
      end

      it "returns (but does not raise) the original exception" do
        expect(content_item_loader.load("/my-missing-item")).to be_a(GdsApi::HTTPErrorResponse)
      end
    end

    context "when the content item schema is in GRAPHQL_ALLOWED_SCHEMAS" do
      subject(:content_item_loader) { described_class.for_request(request) }

      let!(:item_request) { stub_content_store_has_item("/my-random-item", { "schema_name" => "news_article" }) }
      let!(:graphql_request) do
        stub_publishing_api_graphql_has_item(
          "/my-random-item",
          { data: { edition: { schema_name: "news_article" } } },
        )
      end

      context "when the request is made to the draft deployment" do
        let(:item_request) { stub_content_store_has_item("/my-random-item", { "schema_name" => "news_article" }, draft: true) }

        let(:request) do
          instance_double(
            ActionDispatch::Request,
            path: "/my-random-item",
            env: {},
            params: {},
          )
        end

        include_examples "rendered from Draft Content Store"
      end

      context "with graphql param=false" do
        let(:request) do
          instance_double(
            ActionDispatch::Request,
            path: "/my-random-item",
            env: {},
            params: { "graphql" => "false" },
          )
        end

        include_examples "rendered from Content Store"
      end

      context "when the GraphQL A/B test selects the Content Store variant" do
        let(:request) do
          instance_double(
            ActionDispatch::Request,
            path: "/my-random-item",
            env: {},
            params: {},
          )
        end

        before do
          allow(Random).to receive(:rand).with(1.0).and_return(1)
        end

        include_examples "rendered from Content Store"

        context "and with graphql param=false" do
          let(:request) do
            instance_double(
              ActionDispatch::Request,
              path: "/my-random-item",
              env: {},
              params: { "graphql" => "false" },
            )
          end

          include_examples "rendered from Content Store"
        end
      end

      context "when the GraphQL A/B test selects the GraphQL variant" do
        let(:request) do
          instance_double(
            ActionDispatch::Request,
            path: "/my-random-item",
            env: {},
            params: {},
          )
        end

        before do
          allow(Random).to receive(:rand).with(1.0).and_return(0)
        end

        include_examples "rendered from GraphQL"

        context "and with graphql param=false" do
          let(:request) do
            instance_double(
              ActionDispatch::Request,
              path: "/my-random-item",
              env: {},
              params: { "graphql" => "false" },
            )
          end

          include_examples "rendered from Content Store"
        end
      end

      context "with graphql param=true" do
        subject(:content_item_loader) { described_class.for_request(request) }

        let(:graphql_request) do
          stub_publishing_api_graphql_has_item(
            "/my-random-item",
            { data: { edition: { schema_name: "news_article" } } },
          )
        end
        let(:request) { instance_double(ActionDispatch::Request, path: "/my-random-item", env: {}, params: { "graphql" => "true" }) }

        include_examples "rendered from GraphQL"

        it "sets the appropriate prometheus labels" do
          content_item_loader.load("/my-random-item")

          expect(request.env["govuk.prometheus_labels"]).to include({
            "graphql_status_code" => 200,
            "graphql_api_timeout" => false,
          })
        end
      end

      context "when given a bad response code from publishing-api" do
        subject(:content_item_loader) { described_class.for_request(request) }

        let!(:graphql_request) { stub_publishing_api_graphql_does_not_have_item("/my-random-item") }
        let(:request) { instance_double(ActionDispatch::Request, path: "/my-random-item", env: {}, params: { "graphql" => "true" }) }

        it "falls back to loading from Content Store" do
          content_item_loader.load("/my-random-item")

          expect(graphql_request).to have_been_made
          expect(item_request).to have_been_made
        end

        it "reports bad status codes for graphql requests" do
          content_item_loader.load("/my-random-item")

          expect(request.env["govuk.prometheus_labels"]["graphql_status_code"]).to eq(404)
        end
      end

      context "when GDS API Adapters times-out the request" do
        subject(:content_item_loader) { described_class.for_request(request) }

        let(:request) { instance_double(ActionDispatch::Request, path: "/my-random-item", env: {}, params: { "graphql" => "true" }) }

        before do
          publishing_api_adapter = instance_double(GdsApi::PublishingApi)
          allow(GdsApi).to receive(:publishing_api).and_return(publishing_api_adapter)
          allow(publishing_api_adapter).to receive(:graphql_live_content_item)
            .and_raise(GdsApi::TimedOutException)
        end

        it "falls back to loading from Content Store" do
          content_item_loader.load("/my-random-item")

          expect(item_request).to have_been_made
        end

        it "reports bad status codes for graphql requests" do
          content_item_loader.load("/my-random-item")

          expect(request.env["govuk.prometheus_labels"]["graphql_api_timeout"]).to be(true)
        end
      end
    end

    context "when the content item schema is not in GRAPHQL_ALLOWED_SCHEMAS" do
      subject(:content_item_loader) { described_class.for_request(request) }

      let!(:item_request) { stub_content_store_has_item("/my-random-item", { "schema_name" => "guide" }) }
      let(:graphql_request) do
        stub_publishing_api_graphql_has_item(
          "/my-random-item",
          { data: { edition: { schema_name: "some_other_schema" } } },
        )
      end

      context "with ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE=true" do
        subject(:content_item_loader) { described_class.new }

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

      context "with graphql param=true" do
        let(:request) do
          instance_double(
            ActionDispatch::Request,
            path: "/my-random-item",
            env: {},
            params: { "graphql" => "true" },
          )
        end

        include_examples "rendered from Content Store"
      end

      context "when the GraphQL A/B test selects the Content Store variant" do
        let(:request) do
          instance_double(
            ActionDispatch::Request,
            path: "/my-random-item",
            env: {},
            params: {},
          )
        end

        before do
          allow(Random).to receive(:rand).with(1.0).and_return(1)
        end

        include_examples "rendered from Content Store"
      end

      context "when the GraphQL A/B test selects the GraphQL variant" do
        let(:request) do
          instance_double(
            ActionDispatch::Request,
            path: "/my-random-item",
            env: {},
            params: {},
          )
        end

        before do
          allow(Random).to receive(:rand).with(1.0).and_return(0)
        end

        include_examples "rendered from Content Store"
      end
    end
  end
end
