RSpec.describe PublicationPresenter do
  subject(:publication_presenter) { described_class.new(Publication.new(content_store_response)) }

  let(:content_store_response) { GovukSchemas::Example.find("publication", example_name: "publication") }

  it_behaves_like "it supports the national statistics logo", Publication

  describe "#hide_from_search_engines?" do
    it "returns false" do
      expect(publication_presenter.hide_from_search_engines?).to be false
    end

    context "when the page is in the hide list" do
      let(:content_store_response) do
        GovukSchemas::Example.find("publication", example_name: "publication").merge({
          "base_path" => "/government/publications/govuk-app-testing-privacy-notice-how-we-use-your-data",
        })
      end

      it "returns true" do
        expect(publication_presenter.hide_from_search_engines?).to be true
      end
    end
  end
end
