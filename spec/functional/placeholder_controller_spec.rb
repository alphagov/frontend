RSpec.describe PlaceholderController, type: :controller do
  context "loading the placeholder page" do
    it "responds with success" do
      get(:show)

      assert_response(:success)
    end
  end
end
