RSpec.describe HistoryPresenter do
  subject(:history_presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("history", example_name: "history") }
  let(:content_item) { History.new(content_store_response) }

  describe "#breadcrumbs" do
    it "has home and history breadcrumbs" do
      expect(history_presenter.breadcrumbs.count).to eq(2)
    end
  end
end
