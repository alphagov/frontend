RSpec.describe "Fatality Notice" do
  let(:base_path) { "/government/fatalities/sad-news" }

  before do
    content_store_has_example_item(base_path, schema: :fatality_notice)
  end

  describe "GET show" do
    it "returns 200" do
      get base_path

      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      get base_path

      expect(response).to render_template(:show)
    end

    it "sets cache-control headers" do
      get base_path
      expect(response).to honour_content_store_ttl
    end
  end
end
