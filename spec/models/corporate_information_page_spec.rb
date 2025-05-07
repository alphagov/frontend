RSpec.describe CorporateInformationPage do
  let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page_with_groups") }

  let(:corporate_information_page) { described_class.new(content_store_response) }

  describe "#default_organisation" do
    it "returns the organisation that is also present in the organisations list" do
      expected_organisation_id = content_store_response["details"]["organisation"]

      organisation = corporate_information_page.default_organisation

      expect(organisation.content_id).to eq(expected_organisation_id)
      expect(organisation).to be_instance_of(Organisation)
    end

    it "returns nil if the organisation is not present in the organisations list" do
      content_store_response["details"].delete("organisation")

      expect(corporate_information_page.default_organisation).to be_nil
    end
  end
end
