RSpec.describe "Bad request handling" do
  include ContentStoreHelpers

  context "when a bad url is requested" do
    it "returns 400" do
      get "/BAD-REQUEST"

      expect(response).to have_http_status(:bad_request)
    end
  end
end
