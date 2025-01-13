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
end
