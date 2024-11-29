RSpec.describe "Call For Evidence" do
  before do
    content_store_has_example_item("/government/calls-for-evidence/setting-the-grade-standards-of-new-gcses-in-england-2017-2018", schema: :call_for_evidence, example: :call_for_evidence_outcome)
  end

  context "when loading the show page" do
    it "returns 200" do
      get "/government/calls-for-evidence/setting-the-grade-standards-of-new-gcses-in-england-2017-2018"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Call for evidence")
    end
  end
end
