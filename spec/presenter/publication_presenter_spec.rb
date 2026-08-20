RSpec.describe PublicationPresenter do
  subject(:publication_presenter) { described_class.new(Publication.new(content_store_response)) }

  let(:content_store_response) { GovukSchemas::Example.find("publication", example_name: "publication") }

  it_behaves_like "it supports the national statistics logo", Publication

  describe "#hide_from_search_engines?" do
    it "returns false" do
      expect(publication_presenter.hide_from_search_engines?).to be false
    end

    context "when a page is in the hide list" do
      %w[
        /government/publications/govuk-app-testing-privacy-notice-how-we-use-your-data
        /government/publications/govuk-test-app-privacy-notice
        /government/publications/pension-credit-claim-form--2
        /government/publications/hpv-self-testing-kit-instructions
        /government/publications/hpv-self-testing-a-self-test-to-help-protect-against-cervical-cancer
        /government/publications/hpv-self-testing-easy-read-letter-templates
        /government/publications/hpv-self-testing-easy-guides
      ].each do |path|
        let(:content_store_response) do
          GovukSchemas::Example.find("publication", example_name: "publication").merge({
            "base_path" => path,
          })
        end

        it "#{path} returns true" do
          expect(publication_presenter.hide_from_search_engines?).to be true
        end
      end
    end
  end
end
