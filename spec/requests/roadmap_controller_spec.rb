RSpec.describe RoadmapController, type: :request do
  context "GET index" do
    before do
      content_store_has_random_item(base_path: "/roadmap", schema: "special_route")
    end

    it "sets the cache expiry headers" do
      get "/roadmap"

      expect(response.headers["Cache-Control"]).to eq("max-age=#{30.minutes.to_i}, public")
    end
  end
end
