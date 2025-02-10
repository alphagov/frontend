RSpec.describe CorporateInformationPage do
  let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page") }

  describe "#organisation_logo" do
    it "presents the logo for organisations" do
      expected_organisation = content_store_response["links"]["organisations"].first

      logo = described_class.new(content_store_response).organisation_logo(expected_organisation)

      expect(logo[:organisation][:brand]).to eq(expected_organisation["details"]["brand"])
      expect(logo[:organisation][:url]).to eq(expected_organisation["base_path"])
      expect(logo[:organisation][:crest]).to eq(expected_organisation["details"]["logo"]["crest"])
      expect(logo[:organisation][:name]).to eq(expected_organisation["details"]["logo"]["formatted_title"])
    end

    it "includes an image organisation with a custom logo" do
      expected_organisation = content_store_response["links"]["organisations"].first
      expected_organisation["details"]["logo"]["image"] = {
        "url" => "url",
        "alt_text" => "alt_text",
      }

      logo = described_class.new(content_store_response).organisation_logo(expected_organisation)

      expect(logo[:organisation][:image][:url]).to eq(expected_organisation["details"]["logo"]["image"]["url"])
      expect(logo[:organisation][:image][:alt_text]).to eq(expected_organisation["details"]["logo"]["image"]["alt_text"])
    end

    it "returns nil if organisation logo details are not available" do
      content_store_response["links"]["organisations"].first["details"].delete("logo")

      expect(described_class.new(content_store_response).organisation_logo).to be_nil
    end
  end

  describe "#organisation_brand_class" do
    it "presents the brand colour class for organisations" do
      expected_organisation = content_store_response["links"]["organisations"].first

      expect(described_class.new(content_store_response).organisation_brand_class(expected_organisation)).to eq("#{expected_organisation['details']['brand']}-brand-colour")
    end

    it "alters the brand for organisations with an executive order crest" do
      content_store_response["links"]["organisations"].first["details"]["logo"]["crest"] = "eo"
      expected_organisation = content_store_response["links"]["organisations"].first

      expect(described_class.new(content_store_response).organisation_brand_class(expected_organisation)).to eq("executive-office-brand-colour")
    end

    it "has no branding when organisation is not set" do
      content_store_response["links"].delete("organisations")

      expect(described_class.new(content_store_response).organisation_brand_class).to be_nil
    end
  end

  describe "#default_organisation" do
    it "returns the organisation if it is present in the organisations list" do
      expected_organisation = content_store_response["details"]["organisation"]
      organisation = described_class.new(content_store_response).default_organisation

      expect(organisation["content_id"]).to eq(expected_organisation)
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
    it "includes group links that are guids" do
      presented_groups = described_class.new(content_store_response).corporate_information

      expect(presented_groups.first[:links].first).to eq({ title: "Complaints procedure", path: "/government/organisations/department-of-health/about/complaints-procedure" })
    end

    it "includes group links that are internal links with paths and no GUID" do
      presented_groups = described_class.new(content_store_response).corporate_information

      expect(presented_groups.first[:links].last).to eq({ title: "Corporate reports", path: "/government/publications?departments%5B%5D=department-of-health&publication_type=corporate-reports" })
    end

    it "includes group links that are external" do
      presented_groups = described_class.new(content_store_response).corporate_information

      expect(presented_groups.last[:links].last).to eq({ title: "Jobs", path: "https://www.civilservicejobs.service.gov.uk/csr" })
    end

    it "includes group headings" do
      presented_groups = described_class.new(content_store_response).corporate_information

      expect(presented_groups.first[:title]).to eq("Access our information")
      expect(presented_groups.first[:id]).to eq("access-our-information")
    end
  end
end
