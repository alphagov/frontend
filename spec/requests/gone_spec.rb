RSpec.describe "Gone" do
  describe "GET index" do
    let(:base_path) { "/government/publications/berkshires-national-nature-reserve" }

    before do
      stub_content_store_has_item(base_path, schema_name: "gone")
    end

    it "redirects the gone item to the gone controller" do
      get "/government/publications/berkshires-national-nature-reserve"

      expect(response).to have_http_status(:gone)
    end

    it "renders the show template" do
      get base_path

      expect(response).to render_template(:show)
    end

    it "sets cache-control headers" do
      get base_path

      expect(response).to honour_content_store_ttl
    end

    it "renders gone pages correctly when they have a locale" do
      stub_content_store_has_item("/government/publications/berkshires-national-nature-reserve.cy", {
        schema_name: "gone",
        title: "Test",
        base_path: "/government/publications/berkshires-national-nature-reserve.cy",
        locale: :cy,
      })
      get "/government/publications/berkshires-national-nature-reserve.cy", params: { locale: "cy" }

      expect(response).to have_http_status(:gone)
      expect(response).to render_template(:show)
    end
  end
end
