RSpec.describe Guide do
  subject(:guide) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide") }

  it_behaves_like "it has parts", "guide", "guide"

  describe "#hide_chapter_navigation?" do
    it "returns false" do
      expect(guide.hide_chapter_navigation?).to be false
    end

    context "when details/hide_chapter_navigation is true" do
      let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide-with-hide-navigation") }

      it "returns true" do
        expect(guide.hide_chapter_navigation?).to be true
      end
    end
  end

  describe "#is_child_benefit?" do
    it "returns false" do
      expect(guide.is_child_benefit?).to be false
    end

    context "when the base_path is /child-benefit" do
      let(:content_store_response) do
        GovukSchemas::Example.find("guide", example_name: "guide").tap { |i| i.merge!("base_path" => "/child-benefit") }
      end

      it "returns true" do
        expect(guide.is_child_benefit?).to be true
      end
    end
  end

  describe "#part_of_step_navs?" do
    it "returns false" do
      expect(guide.part_of_step_navs?).to be false
    end

    context "when the content item is part of a step by step navigation" do
      let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide-with-step-navs") }

      it "returns true" do
        expect(guide.part_of_step_navs?).to be true
      end
    end
  end
end
