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

RSpec.shared_examples "it can have document heading" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }
  context "when it has section id and title" do
    it "knows it has document heading with section id and title" do
      content_item["details"]["section_id"] = "VATGPB2000"
      expect(described_class.new(content_item).document_heading).to eq(["VATGPB2000", "What is content design?"])
    end
  end

  context "when it has only title" do
    it "adds title to document heading" do
      expect(described_class.new(content_item).document_heading).to eq(["What is content design?"])
    end
  end

  context "when there is no title" do
    it "does not add title if it is missing" do
      content_item.delete("title")
      expect(described_class.new(content_item).document_heading).to be_nil
    end
  end
end

RSpec.shared_examples "it can have breadcrumbs" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  context "when show_contents_list? is true" do
    it "knows it has Manual homepage breadcrumbs" do
      content_item["links"]["organisations"][0]["content_id"] = "dcc907d6-433c-42df-9ffb-d9c68be5dc4d"
      expect(described_class.new(content_item).breadcrumbs).to eq([{ title: "Manual homepage", url: "/guidance/content-design/what-is-content-design" }])
    end
  end

  context "when show_contents_list? is false" do
    it "knows it has Back to contents breadcrumbs" do
      expect(described_class.new(content_item).breadcrumbs).to eq([{ title: "Back to contents", url: "/guidance/content-design/what-is-content-design" }])
    end
  end
end
