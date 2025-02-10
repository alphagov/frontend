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

  describe "#corporate_information?" do
    it "presents corporate information groups on about pages" do
      expect(described_class.new(content_store_response).corporate_information?).to be(true)
    end

    it "does not present corporate information groups on about pages if information isn't available" do
      content_store_response["details"]["corporate_information_groups"] = nil

      expect(described_class.new(content_store_response).corporate_information?).to be(false)
    end
  end

  describe "#corporate_information" do
    subject(:corporate_information) { described_class.new(content_store_response).corporate_information }

    it "excludes group links that do not have matching guids" do
      groups = content_store_response.dig("details", "corporate_information_groups")
      groups.first["contents"] << "123"

      corporate_information = described_class.new(content_store_response).corporate_information

      expect(corporate_information.first[:links].count).not_to eq(groups.count)
    end

    it "includes group links that are guids" do
      expect(corporate_information.first[:links].first).to eq({ title: "Complaints procedure", path: "/government/organisations/department-of-health/about/complaints-procedure" })
    end

    it "includes group links that are internal links with paths and no GUID" do
      expect(corporate_information.first[:links].last).to eq({ title: "Corporate reports", path: "/government/publications?departments%5B%5D=department-of-health&publication_type=corporate-reports" })
    end

    it "includes group links that are external" do
      expect(corporate_information.last[:links].last).to eq({ title: "Jobs", path: "https://www.civilservicejobs.service.gov.uk/csr" })
    end

    it "includes group headings" do
      expect(corporate_information.first[:title]).to eq("Access our information")
      expect(corporate_information.first[:id]).to eq("access-our-information")
    end
  end

  describe "#corporate_information_page" do
    subject(:corporate_information_pages) { described_class.new(content_store_response).corporate_information_page }

    it "models the corporate information pages" do
      expect(corporate_information_pages.first).to be_instance_of(ContentItem)
    end

    it "returns all the avalilable corporate information pages" do
      expected_pages = content_store_response["links"]["corporate_information_pages"]

      expect(corporate_information_pages.count).to eq(expected_pages.count)
    end
  end
end
