RSpec.describe "Fatality Notice" do
  before do
    content_store_has_example_item("/government/fatalities/sad-news", schema: :fatality_notice)
  end

  describe "GET show" do
    it "returns 200" do
      get "/government/fatalities/sad-news"

      expect(response).to have_http_status(:ok)
    end
  end
end
