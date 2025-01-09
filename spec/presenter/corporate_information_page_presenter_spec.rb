RSpec.describe CorporateInformationPagePresenter do
  let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page") }
  let(:content_item) { CorporateInformationPage.new(content_store_response) }
  let(:presenter) { described_class.new(content_item) }

  describe "#page_title" do
    it "presents the organisation in the title" do
      expect(presenter.page_title).to eq("About us - Department of Health")
    end

    it "does not present an organisation in the title when it is not present in links" do
      content_store_response["links"] = {}
      expect(presenter.page_title).to eq("About us")
    end

    it "presents withdrawn in the title for withdrawn content" do
      content_store_response["withdrawn_notice"] = { "explanation": "Withdrawn", "withdrawn_at": "2014-08-22T10:29:02+01:00" }
      expect(presenter.page_title).to eq("[Withdrawn] About us - Department of Health")
    end
  end
end
