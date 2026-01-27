RSpec.describe ManualSectionPresenter do
  subject(:manual_section_presenter) { described_class.new(content_item) }

  let(:content_item) { ManualSection.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("manual_section", example_name: "what-is-content-design") }

  it_behaves_like "it can have manual metadata", Manual

  describe "#page_title" do
    it "returns the manual name, section name, plus Guidance" do
      expect(manual_section_presenter.page_title).to eq("Content design: planning, writing and managing content - What is content design? - Guidance")
    end
  end
end
