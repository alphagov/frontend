RSpec.describe "HMRC Manual" do
  before do
    stub_content_store_does_not_have_item("/hmrc-internal-manuals")
    content_store_has_example_item("/hmrc-internal-manuals/vat-government-and-public-bodies", schema: :hmrc_manual, example: "vat-government-public-bodies")
  end

  describe "GET show" do
    let(:base_path) { "/hmrc-internal-manuals/vat-government-and-public-bodies" }

    it "returns 200" do
      get base_path

      expect(response).to have_http_status(:ok)
    end

    it "renders the HMRC show template" do
      get base_path

      expect(response).to render_template(:show)
    end

    it "sets cache-control headers" do
      get base_path
      expect(response).to honour_content_store_ttl
    end
  end
end
