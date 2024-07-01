require "gds_api/test_helpers/content_store"

RSpec.describe TravelAdviceController, type: :controller do
  include GdsApi::TestHelpers::ContentStore

  context "GET index" do
    context "given countries exist" do
      before do
        @content_item = GovukSchemas::Example.find("travel_advice_index", example_name: "index")
        base_path = @content_item.fetch("base_path")
        stub_content_store_has_item(base_path, @content_item)
      end

      it "succeeds" do
        get(:index)

        expect(response.successful?).to be true
      end

      it "renders the index template" do
        get(:index)

        assert_template("index")
      end

      it "sets cache-control headers" do
        get(:index)
        honours_content_store_ttl
      end

      context "requesting atom" do
        before { get(:index, format: "atom") }

        it "returns an aggregate of country atom feeds" do
          expect(response.status).to eq(200)
          expect(response.headers["Content-Type"]).to eq("application/atom+xml; charset=utf-8")
        end

        it "sets the cache-control headers to 5 mins" do
          expect(response.headers["Cache-Control"]).to eq("max-age=#{5.minutes.to_i}, public")
        end

        it "sets the Access-Control-Allow-Origin header" do
          expect(response.headers["Access-Control-Allow-Origin"]).to eq("*")
        end
      end
    end
  end
end
