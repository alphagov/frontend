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

  describe "#organisation_logo" do
    it "presents the logo for organisations" do
      expected_organisation = content_store_response["links"]["organisations"].first
      logo = presenter.organisation_logo

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

      logo = presenter.organisation_logo

      expect(logo[:organisation][:image][:url]).to eq(expected_organisation["details"]["logo"]["image"]["url"])
      expect(logo[:organisation][:image][:alt_text]).to eq(expected_organisation["details"]["logo"]["image"]["alt_text"])
    end
  end

  describe "#organisation_brand_class" do
    it "presents the brand colour class for organisations" do
      expected_organisation = content_store_response["links"]["organisations"].first

      expect(presenter.organisation_brand_class).to eq("#{expected_organisation['details']['brand']}-brand-colour")
    end

    it "alters the brand for organisations with an executive order crest" do
      expected_organisation = content_store_response["links"]["organisations"].first

      expected_organisation["details"]["logo"]["crest"] = "eo"

      expect(presenter.organisation_brand_class).to eq("executive-office-brand-colour")
    end

    it "has no branding when organisation is not set" do
      content_store_response["links"].delete("organisations")
      expect(presenter.organisation_brand_class).to be_nil
    end
  end
end
