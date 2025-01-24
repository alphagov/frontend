RSpec.describe "Case Study" do
  before do
    content_store_has_example_item("/government/case-studies/get-britain-building-carlisle-park", schema: :case_study)
  end

  describe "GET show" do
    it "returns 200" do
      get "/government/case-studies/get-britain-building-carlisle-park"

      expect(response).to have_http_status(:ok)
    end
  end
end
