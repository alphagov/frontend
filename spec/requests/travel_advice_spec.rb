RSpec.describe "Travel Advice" do
  describe "GET index" do
    context "when countries exist" do
      let(:content_item) { GovukSchemas::Example.find("travel_advice_index", example_name: "index") }
      let(:base_path) { content_item.fetch("base_path") }

      before do
        stub_content_store_has_item(base_path, content_item)
      end

      it "succeeds" do
        get base_path

        expect(response).to have_http_status(:ok)
      end

      it "renders the index template" do
        get base_path

        expect(response).to render_template(:index)
      end

      it "sets cache-control headers" do
        get base_path
        expect(response).to honour_content_store_ttl
      end

      context "when requesting atom" do
        before do
          atom_base_path = "#{base_path}.atom"
          stub_content_store_has_item(atom_base_path, content_item)
          get atom_base_path
        end

        it "returns an aggregate of country atom feeds" do
          expect(response).to have_http_status(:ok)
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

  describe "GET show" do
    let(:content_item) { GovukSchemas::Example.find("travel_advice", example_name: "full-country") }
    let(:country_path) { content_item.fetch("base_path") }

    before do
      stub_content_store_has_item(country_path, content_item)
    end

    context "when viewing the first part" do
      it "succeeds" do
        get country_path

        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        get country_path

        expect(response).to render_template(:show)
      end

      it "renders the print variant" do
        get "#{country_path}/print"

        expect(response).to render_template(:show)
      end

      it "sets cache-control headers" do
        get country_path

        expect(response).to honour_content_store_ttl
      end
    end

    context "when viewing the second part" do
      let(:part_slug) { content_item.dig("details", "parts").last["slug"] }

      it "succeeds" do
        get "#{country_path}/#{part_slug}"

        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        get "#{country_path}/#{part_slug}"

        expect(response).to render_template(:show)
      end

      it "sets cache-control headers" do
        get "#{country_path}/#{part_slug}"
        expect(response).to honour_content_store_ttl
      end
    end

    context "when viewing a missing part" do
      it "redirects to the base_path if the part doesn't exist" do
        get "#{country_path}/i-dont-exist"

        expect(response).to redirect_to(country_path)
      end
    end
  end
end
