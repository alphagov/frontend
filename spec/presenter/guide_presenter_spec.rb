RSpec.describe GuidePresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide") }
  let(:content_item) { Guide.new(content_store_response) }

  describe "#title" do
    it "returns the content_item title" do
      expect(presenter.title).to eq(content_item.title)
    end

    context "when hide_chapter_navigation is true in the content item" do
      context "when in a step by step guide" do
        let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide-with-step-navs-and-hide-navigation") }

        it "returns the first part title" do
          expect(presenter.title).to eq(content_item.parts.first["title"])
        end
      end
    end
  end
end