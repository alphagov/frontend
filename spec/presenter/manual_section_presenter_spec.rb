RSpec.describe ManualSectionPresenter do
  subject(:presenter) { described_class.new(ManualSection.new(content_store_response)) }

  let(:content_store_response) { GovukSchemas::Example.find("manual_section", example_name: "what-is-content-design") }

  it_behaves_like "it can have manual metadata", ManualSection
  # it_behaves_like "it can set the manual page title", ManualSection

  describe "#page_title" do
    it "returns the correct page title" do
      expect(presenter.page_title)
      .to eq("Content design: planning, writing and managing content - What is content design? - Guidance")
    end
  end
end
