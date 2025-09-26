RSpec.shared_examples "it can have manual title" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it has manual title" do
    expect(described_class.new(content_item).title).to eq(content_item.dig("links", "manual").first["title"])
  end
end

RSpec.shared_examples "it can have page title" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  context "when schema is hmrc manual" do
    before do
      content_item["schema_name"] = "hmrc_manual_section"
    end

    it "knows it has page title" do
      expect(described_class.new(content_item).page_title).to eq("Content design: planning, writing and managing content - What is content design? - HMRC internal manual")
    end

    it "does not add separator when title is blank" do
      content_item["title"] = ""
      expect(described_class.new(content_item).page_title).to eq("Content design: planning, writing and managing content - HMRC internal manual")
    end
  end

  context "when schema is not hmrc manual" do
    it "knows it has page title" do
      expect(described_class.new(content_item).page_title).to eq("Content design: planning, writing and managing content - What is content design? - Guidance")
    end

    it "does not add separator when title is blank" do
      content_item["title"] = ""
      expect(described_class.new(content_item).page_title).to eq("Content design: planning, writing and managing content - Guidance")
    end
  end

  context "when section id is present" do
    it "returns the section id" do
      content_item["details"]["section_id"] = "Section1"
      expect(described_class.new(content_item).page_title).to eq("Section1 - What is content design? - Guidance")
    end
  end

  context "when section id is not present" do
    it "returns the title" do
      expect(described_class.new(content_item).page_title).to eq("Content design: planning, writing and managing content - What is content design? - Guidance")
    end
  end
end
