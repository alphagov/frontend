RSpec.describe ManualSection do
  subject(:manual_section) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("manual_section", example_name: "what-is-content-design") }

  it_behaves_like "it can have manual title", "manual_section", "what-is-content-design"
  it_behaves_like "it can have page title", "manual_section", "what-is-content-design"
  it_behaves_like "it can have document heading", "manual_section", "what-is-content-design"
  it_behaves_like "it can have breadcrumbs", "manual_section", "what-is-content-design"
  it_behaves_like "it can have manual base path", "manual_section", "what-is-content-design"
  it_behaves_like "it can have section groups", "manual", "content-design"
  it_behaves_like "it can be a manual", "manual", "content-design"
  it_behaves_like "it can be a manual section", "manual_section", "what-is-content-design"

  describe "#intro" do
    it "returns nil" do
      expect(manual_section.intro).to be_nil
    end

    context "when an intro is present" do
      let(:content_store_response) do
        GovukSchemas::Example.find("manual_section", example_name: "what-is-content-design").tap do |item|
          item["details"]["body"] = "<p>Hello</p><h2 id=\"one\">1</h2><p>Section 1 body</p>"
        end
      end

      it "returns the intro" do
        expect(manual_section.intro).to eq("<p>Hello</p>")
      end
    end
  end

  describe "#sections" do
    it "returns a list of sections with headings" do
      expect(manual_section.sections.count).to eq(7)
      expect(manual_section.sections.first[:heading][:text]).to eq("Designing content, not creating copy")
      expect(manual_section.sections.first[:heading][:id]).to eq("designing-content-not-creating-copy")
      expect(manual_section.sections.first[:content]).to start_with("<p>Good content design allows")
    end

    context "when there are no sections" do
      let(:content_store_response) do
        GovukSchemas::Example.find("manual_section", example_name: "what-is-content-design").tap do |item|
          item["details"]["body"] = "<p>Hello</p>"
        end
      end

      it "returns an empty list" do
        expect(manual_section.sections).to eq([])
      end
    end
  end

  describe "#visually_expanded?" do
    it "returns false" do
      expect(manual_section.visually_expanded?).to be false
    end

    context "when visually_expanded is true in the content item" do
      let(:content_store_response) do
        GovukSchemas::Example.find("manual_section", example_name: "what-is-content-design").tap do |item|
          item["details"]["visually_expanded"] = "true"
        end
      end

      it "returns true" do
        expect(manual_section.visually_expanded?).to be true
      end
    end
  end
end
