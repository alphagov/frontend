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
end
