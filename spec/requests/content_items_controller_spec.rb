RSpec.describe ContentItemsController do
  before do
    content_store_has_example_item("/government/case-studies/get-britain-building-carlisle-park", schema: :case_study)
  end

  describe "GET path" do
    it "sets GOVUK-Account-Session-Flash in the Vary header" do
      get "/government/case-studies/get-britain-building-carlisle-park"

      expect(response.headers["Vary"]).to include("GOVUK-Account-Session-Flash")
    end
  end
end
