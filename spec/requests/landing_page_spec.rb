RSpec.describe "Landing Page" do
  context "GET show" do
    context "when a content item does exist" do
      before do
        stub_const("LandingPage::ADDITIONAL_CONTENT_PATH", "spec/fixtures")
        @content_item = GovukSchemas::Example.find("landing_page", example_name: "landing_page")
        @base_path = @content_item.fetch("base_path")
        stub_content_store_has_item(@base_path, @content_item)
      end

      it "succeeds" do
        get @base_path

        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        get @base_path

        expect(response).to render_template(:show)
      end
    end

    context "when a content item does not exist" do
      let(:base_path) { "/landing-page" }

      before do
        stub_const("LandingPage::ADDITIONAL_CONTENT_PATH", "spec/fixtures")
        stub_content_store_does_not_have_item(base_path)
      end

      it "succeeds" do
        get base_path

        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        get base_path

        expect(response).to render_template(:show)
      end
    end
  end
end
