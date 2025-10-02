RSpec.describe GuidePresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide") }
  let(:content_item) { Guide.new(content_store_response) }

  describe "#page_title" do
    it "returns the content item title and part title" do
      expect(presenter.page_title).to eq("#{content_item.title}: #{content_item.current_part_title}")
    end
  end

  describe "#show_guide_navigation?" do
    it "returns true" do
      expect(presenter.show_guide_navigation?).to be true
    end

    context "when content item is part of a step-by-step, and details/hide_chapter_navigation is true" do
      let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide-with-step-navs-and-hide-navigation") }

      it "returns false" do
        expect(presenter.show_guide_navigation?).to be false
      end
    end

    context "when there is only one part of the guide" do
      let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "single-page-guide") }

      it "returns false" do
        expect(presenter.show_guide_navigation?).to be false
      end
    end
  end

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
