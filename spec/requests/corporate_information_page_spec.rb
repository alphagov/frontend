RSpec.describe "Corporate Information Page" do
  before do
    content_store_has_example_item("/government/organisations/government-digital-service/about", schema: :corporate_information_page, example: "corporate_information_page_with_groups")
    content_store_has_example_item("/government/organisations/government-digital-service/about/our-governance", schema: :corporate_information_page, example: "corporate_information_page_with_groups")
  end

  describe "GET show" do
    it "returns 200" do
      get "/government/organisations/government-digital-service/about"

      expect(response).to have_http_status(:ok)

      get "/government/organisations/government-digital-service/about/our-governance"

      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      get "/government/organisations/government-digital-service/about"

      expect(response).to render_template(:show)
    end
  end
end
