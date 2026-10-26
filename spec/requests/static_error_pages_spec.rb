RSpec.describe "Static Error Pages" do
  it "can render pages for all errors supported by the controller" do
    StaticErrorPagesController::ERROR_CODES.each do |code|
      get "/static-error-pages/#{code}.html"

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to be_empty
    end
  end

  context "when asked for an unrecognised error" do
    it "returns a 404 with no body" do
      get "/static-error-pages/555.html"

      expect(response).to have_http_status(:not_found)
      expect(response.body).to be_empty
    end
  end
end
