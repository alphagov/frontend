RSpec.describe "Guide" do
  describe "GET show" do
    let(:content_item) { GovukSchemas::Example.find("guide", example_name: "guide") }
    let(:guide_path) { content_item.fetch("base_path") }

    before do
      stub_content_store_has_item(guide_path, content_item)
    end

    context "when viewing the first part" do
      it "succeeds" do
        get guide_path

        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        get guide_path

        expect(response).to render_template(:show)
      end

      it "sets cache-control headers" do
        get guide_path

        expect(response).to honour_content_store_ttl
      end
    end

    context "when viewing the last part" do
      let(:part_slug) { content_item.dig("details", "parts").last["slug"] }

      it "succeeds" do
        get "#{guide_path}/#{part_slug}"

        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        get "#{guide_path}/#{part_slug}"

        expect(response).to render_template(:show)
      end

      it "sets cache-control headers" do
        get "#{guide_path}/#{part_slug}"
        expect(response).to honour_content_store_ttl
      end
    end

    context "when viewing a missing part" do
      it "redirects to the base_path if the part doesn't exist" do
        get "#{guide_path}/i-dont-exist"

        expect(response).to redirect_to(guide_path)
      end
    end
  end
end
