RSpec.describe ManualSectionPresenter do
  subject(:manual_section_presenter) { described_class.new(content_item) }

  let(:content_item) { ManualSection.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("manual_section", example_name: "what-is-content-design") }

  it_behaves_like "it can have manual metadata", Manual


  describe "#contents_outline_presenter" do
    it "returns a ContentsOutlinePresenter loaded from the content item" do
      expect(manual_section_presenter.contents_outline_presenter).to be_instance_of(ContentsOutlinePresenter)
      expect(manual_section_presenter.contents_outline_presenter.for_contents_list_component.count).to eq(7)
    end
  end

  describe "#show_contents_list?" do
    it "returns false" do
      expect(manual_section_presenter.show_contents_list?).to be false
    end

    context "when the manual is published by the Ministry of Justice" do
      let(:content_store_response) do
        GovukSchemas::Example.find("manual_section", example_name: "what-is-content-design").tap do |item|
          item["links"]["organisations"][0]["content_id"] = "dcc907d6-433c-42df-9ffb-d9c68be5dc4d"
        end
      end

      it "returns true" do
        expect(manual_section_presenter.show_contents_list?).to be true
      end
    end
  end
end
