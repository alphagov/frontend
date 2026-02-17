RSpec.describe "Consultation" do
  let(:content_item) { GovukSchemas::Example.find("consultation", example_name: "open_consultation") }
  let(:base_path) { content_item.fetch("base_path") }

  before do
    stub_content_store_has_item(base_path, content_item)
  end

  describe "GET show" do
    context "when visiting a Consultation page" do
      it "returns 200" do
        get base_path

        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        get base_path

        expect(response).to render_template("show")
      end
    end
  end

  describe "Vary headers" do
    it "sets GOVUK-Account-Session-Flash in the Vary header" do
      get base_path

      expect(response.headers["Vary"]).to include("GOVUK-Account-Session-Flash")
    end
  end
end
