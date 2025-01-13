RSpec.describe CorporateInformationPage do
  let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page") }

  describe "#organisation_brand_class" do
    it "presents the brand colour class for organisations" do
      expected_organisation = Organisation.new(content_store_response["links"]["organisations"].first)

      expect(described_class.new(content_store_response).organisation_brand_class).to eq("#{expected_organisation.brand}-brand-colour")
    end

    it "has no branding when organisation is not set" do
      content_store_response["links"].delete("organisations")

      expect(described_class.new(content_store_response).organisation_brand_class).to be_nil
    end
  end

  describe "#default_organisation" do
    it "returns the organisation that is also present in the organisations list" do
      expected_organisation_id = content_store_response["details"]["organisation"]

      organisation = described_class.new(content_store_response).default_organisation

      expect(organisation.content_id).to eq(expected_organisation_id)
      expect(organisation).to be_instance_of(Organisation)
    end

    it "returns nil if the organisation is not present in the organisations list" do
      content_store_response["details"].delete("organisation")

      expect(described_class.new(content_store_response).default_organisation).to be_nil
    end
  end
end
