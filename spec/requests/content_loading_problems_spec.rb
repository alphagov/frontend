RSpec.describe "Content Loading Problems" do
  context "loading the homepage without permission" do
    before do
      endpoint = content_store_endpoint(draft: false)
      stub_request(:get, "#{endpoint}/content/").to_return(status: 403, headers: {})
    end

    it "responds with a 403 (matching the response from content store)" do
      get "/"

      expect(response).to have_http_status(:forbidden)
    end
  end

  context "loading /foreign-travel-advice when the content-store is missing" do
    before do
      stub_content_store_isnt_available
    end

    it "responds with a 503 (matching the response from content store)" do
      get "/foreign-travel-advice"

      expect(response).to have_http_status(:service_unavailable)
    end
  end
end
