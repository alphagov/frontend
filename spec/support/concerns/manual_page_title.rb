RSpec.shared_examples "it can set the manual page title" do |content_item_class|
  subject(:presenter) { described_class.new(content_item) }

  context "when the content_item is manual" do
    let(:content_item) { instance_double(content_item_class, title: "test-manual", hmrc?: false) }

    it "returns page title for manual" do
      expect(presenter.page_title).to eq("test-manual - Guidance")
    end
  end

  context "when the content_item is hmrc" do
    let(:content_item) { instance_double(content_item_class, title: "test-hmrc-manual", hmrc?: true) }

    it "returns page title for hmrc manual" do
      expect(presenter.page_title).to eq("test-hmrc-manual - HMRC internal manual")
    end
  end

  context "when content_item title is not present" do
    let(:content_item) { instance_double(content_item_class, title: "", hmrc?: false) }

    it "returns page title having only guidance" do
      expect(presenter.page_title).to eq("Guidance")
    end
  end
end
