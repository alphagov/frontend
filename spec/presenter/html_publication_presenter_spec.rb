RSpec.describe HtmlPublicationPresenter do
  subject(:html_publication_presenter) { described_class.new(HtmlPublication.new(content_store_response)) }

  let(:content_store_response) { GovukSchemas::Example.find("html_publication", example_name: "long_form_and_automatically_numbered_headings") }

  describe "#hide_from_search_engines?" do
    it "returns false" do
      expect(html_publication_presenter.hide_from_search_engines?).to be false
    end

    context "when the page is in the hide list" do
      let(:content_store_response) do
        GovukSchemas::Example.find(:html_publication, example_name: "long_form_and_automatically_numbered_headings").tap do |example|
          example["links"]["parent"][0]["base_path"] = "/government/publications/govuk-app-testing-privacy-notice-how-we-use-your-data"
        end
      end

      it "returns true" do
        expect(html_publication_presenter.hide_from_search_engines?).to be true
      end
    end

    context "when the page has no parent" do
      let(:content_store_response) do
        GovukSchemas::Example.find(:html_publication, example_name: "long_form_and_automatically_numbered_headings").tap do |example|
          example["links"]["parent"] = nil
        end
      end

      it "returns false" do
        expect(html_publication_presenter.hide_from_search_engines?).to be false
      end
    end

    context "when the page has an incomplete parent" do
      let(:content_store_response) do
        GovukSchemas::Example.find(:html_publication, example_name: "long_form_and_automatically_numbered_headings").tap do |example|
          example["links"]["parent"][0] = {}
        end
      end

      it "returns false" do
        expect(html_publication_presenter.hide_from_search_engines?).to be false
      end
    end
  end

  describe "#organisation_logos" do
    context "when there is one organisation" do
      let(:content_store_response) do
        GovukSchemas::Example.find(:html_publication, example_name: "arabic_translation")
      end

      it "returns the organisation details" do
        expected = [
          {
            brand: "uk-trade-investment",
            crest: "single-identity",
            image: nil,
            name: "UK Trade<br>&amp; Investment",
            url: "/government/organisations/uk-trade-investment",
          },
        ]
        expect(html_publication_presenter.organisation_logos).to eq(expected)
      end
    end

    context "when there are multiple organisations" do
      let(:content_store_response) do
        GovukSchemas::Example.find(:html_publication, example_name: "long_form_and_automatically_numbered_headings").tap do |example|
          example["links"]["organisations"] << {
            schema_name: "organisation",
            document_type: "organisation",
            title: "Environment Agency",
            details: {
              logo: {
                formatted_title: "Environment Agency",
                image: {
                  url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/organisation/logo/199/EAlogo.png",
                },
              },
            },
            base_path: "/government/organisations/environment-agency",
          }.deep_stringify_keys
        end
      end

      it "returns the organisation details minus any images" do
        expect(html_publication_presenter.organisation_logos[1][:name]).to eq("Environment Agency")
        expect(html_publication_presenter.organisation_logos[1][:image]).to be_nil
      end
    end
  end

  describe "#last_changed" do
    context "when this is the first published version" do
      let(:content_store_response) do
        GovukSchemas::Example.find(:html_publication, example_name: "published_with_history_mode")
      end

      it "gives the date when last updated" do
        expect(html_publication_presenter.last_changed).to eq("Published 17 January 2016")
      end
    end

    context "when this isn't the first published version" do
      let(:content_store_response) do
        GovukSchemas::Example.find(:html_publication, example_name: "published_with_history_mode").tap do |example|
          example["details"]["first_published_version"] = false
        end
      end

      it "gives the date when last updated" do
        expect(html_publication_presenter.last_changed).to eq("Updated 17 January 2016")
      end
    end
  end

  describe "#format_sub_type" do
    context "when the parent has a document type" do
      let(:content_store_response) do
        GovukSchemas::Example.find(:html_publication, example_name: "multiple_organisations").tap do |example|
          example["links"]["parent"][0]["document_type"] = "example_document_type"
        end
      end

      it "outputs the parent document type" do
        expect(html_publication_presenter.format_sub_type).to eq("example_document_type")
      end
    end

    context "when the parent does not exist" do
      let(:content_store_response) do
        GovukSchemas::Example.find(:html_publication, example_name: "multiple_organisations").tap do |example|
          example["links"]["parent"] = nil
        end
      end

      it "outputs the default document type" do
        expect(html_publication_presenter.format_sub_type).to eq("publication")
      end
    end
  end
end
