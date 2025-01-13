RSpec.describe CorporateInformationPage do
  let(:corporate_information_page) { described_class.new(GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page")) }

  it_behaves_like "it can have a contents list", "corporate_information_page", "corporate_information_page"

  describe "#contents_items" do
    it "includes the corporate information heading in the contents list if corporate informations groups are present" do
      expect(corporate_information_page.content_store_response["details"]["corporate_information_groups"].present?).to be(true)

      expect(corporate_information_page.contents_items).to include({ text: "Corporate information", id: "corporate-information" })
    end
  end
end
