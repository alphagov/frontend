RSpec.describe "Static Error Pages" do
  context "when asked for an unrecognised error" do
    it "returns a 404 with no body" do
      get "/static-error-pages/555.html"

      expect(response).to have_http_status(:not_found)
      expect(response.body).to be_empty
    end
  end
end
