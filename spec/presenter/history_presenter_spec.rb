RSpec.describe HistoryPresenter do
  subject(:history_presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("history", example_name: "history") }
  let(:content_item) { History.new(content_store_response) }

  describe "#breadcrumbs" do
    it "has home and history breadcrumbs" do
      expect(history_presenter.breadcrumbs.count).to eq(2)
    end
  end

  describe "#page_title_options" do
    it "has a context" do
      expect(history_presenter.page_title_options[:context]).to eq("History")
    end

    it "has options derived from the content item" do
      expect(history_presenter.page_title_options[:heading_text]).to eq(content_store_response["title"])
      expect(history_presenter.page_title_options[:lead_paragraph]).to eq(content_store_response["details"]["lead_paragraph"])
    end
  end
end
