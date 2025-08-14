RSpec.describe "Gone" do
  describe "GET index" do
    before do
      stub_content_store_has_item("/foreign-travel-advice/grand-fenwick", schema_name: "gone")
    end

    it "redirects the gone item to the gone controller" do
      get "/foreign-travel-advice/grand-fenwick"

      expect(response).to have_http_status(:gone)
    end
  end
end
