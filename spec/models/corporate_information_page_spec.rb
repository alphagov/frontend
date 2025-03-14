RSpec.describe CorporateInformationPage do
  let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page_with_groups") }

  let(:corporate_information_page) { described_class.new(GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page")) }

  it_behaves_like "it can be withdrawn", "corporate_information_page", "best-practice-welsh-language-scheme-withdrawn"
  it_behaves_like "it can have a contents list", "corporate_information_page", "corporate_information_page_without_description"

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

    it "includes group headings" do
      expect(corporate_information.first[:title]).to eq("Access our information")
      expect(corporate_information.first[:id]).to eq("access-our-information")
    end

    context "with 'Access our information' section" do
      it "includes the organisation chart as the first group link if it is available" do
        expect(corporate_information.first[:links].first).to eq({ title: "Our organisation chart", path: "https://data.gov.uk/dataset/04427362-663e-49e0-9103-8bc01dcaa2c7/organogram-of-staff-roles-and-salaries" })
      end

      it "includes group links and titles that have matching guids" do
        expect(corporate_information.first[:links].last).to eq({ title: "Statistics at DHSC", path: "/government/organisations/department-of-health-and-social-care/about/statistics" })
      end

      it "excludes group links that do not have matching guids" do
        groups = content_store_response.dig("details", "corporate_information_groups")
        groups.first["contents"] << "123"

        corporate_information = described_class.new(content_store_response).corporate_information

        expect(corporate_information.first[:links].count).not_to eq(groups.count)
      end
    end

    context "with 'Jobs and contracts' section" do
      it "includes group links that are external" do
        expect(corporate_information.last[:links].last).to eq({ title: "Jobs", path: "https://www.civilservicejobs.service.gov.uk/csr" })
      end
    end
  end

  describe "#corporate_information_pages" do
    subject(:corporate_information_pages) { described_class.new(content_store_response).corporate_information_pages }

    it "models the corporate information pages" do
      expect(corporate_information_pages.first).to be_instance_of(described_class)
    end

    it "returns all the avalilable corporate information pages" do
      expected_pages = content_store_response["links"]["corporate_information_pages"]

      expect(corporate_information_pages.count).to eq(expected_pages.count)
    end
  end
end
