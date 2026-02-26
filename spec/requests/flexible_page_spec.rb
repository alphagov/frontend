RSpec.describe "FlexiblePage" do
  describe "GET show" do
    let(:base_path) { "/flexible-page" }

    before do
      ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = "true"
      stub_const("ContentItemLoaders::LocalFileLoader::LOCAL_ITEMS_PATH", "spec/fixtures/local-content-items")
      get base_path
    end

    after do
      ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = nil
    end

    it "returns 200" do
      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      expect(response).to render_template("show")
    end

    describe "atom format" do
      context "when no feed is present" do
        before do
          stub_content_store_does_not_have_item("/no-feed")
          stub_content_store_does_not_have_item("/no-feed.atom")
          get "/no-feed.atom"
        end

        it "returns 404" do
          expect(response).to have_http_status(:not_found)
        end
      end

      context "when feed is present" do
        before do
          get "#{base_path}.atom?graphql=false"
        end

        it "returns 200" do
          expect(response).to have_http_status(:ok)
        end

        it "returns correct content-type" do
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
