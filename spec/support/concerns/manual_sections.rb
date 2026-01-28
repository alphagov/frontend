require "gds_api/test_helpers/content_store"

RSpec.shared_examples "it can have manual title" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it has manual title" do
    expect(described_class.new(content_item).manual_title).to eq(content_item.dig("links", "manual").first["title"])
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

RSpec.shared_examples "it can have breadcrumb" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  context "when section_id is present" do
    it "returns the section_id" do
      content_item["details"]["section_id"] = "VATGPB2000"
      expect(described_class.new(content_item).breadcrumb).to eq("VATGPB2000")
    end
  end

  context "when section_id is not present" do
    it "returns the manual_title" do
      content_item["details"].delete("section_id") if content_item["details"]["section_id"]
      expect(described_class.new(content_item).breadcrumb)
      .to eq(content_item.dig("links", "manual").first["title"])
    end
  end
end

RSpec.shared_examples "it can have manual base path" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "returns the manual base path" do
    expect(described_class.new(content_item).manual_base_path).to eq(content_item.dig("details", "manual", "base_path"))
  end
end

RSpec.shared_examples "it can have manual content item" do |_document_type, _example_name|
  include GdsApi::TestHelpers::ContentStore

  let(:base_path) { "/test-manual" }

  let(:content_item) do
    {
      "base_path" => base_path,
      "details" => {
        "body" => "Test manual",
        "headers" => [],
        "manual" => {
          "base_path" => "/test-manual",
        },
      },
      "title" => "Manual Content Item",
      "manual" => { "title" => "Test manual" },
      "document_type" => "manual_section",
    }
  end

  before do
    stub_content_store_has_item(base_path, content_item)
  end

  it "returns the manual content item" do
    manual = described_class.new(content_item).manual_content_item
    expect(manual.content_store_response.parsed_content).to include(content_item)
  end
end

RSpec.shared_examples "it checks for hmrc" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  context "when schema_name is hmrc" do
    it "returns true for hmrc manuals" do
      content_item["schema_name"] = "hmrc_manual"
      expect(described_class.new(content_item).hmrc?).to be true
    end
  end

  context "when schema_name is not hmrc" do
    it "returns false for non-hmrc manuals" do
      content_item["schema_name"] = "manual"
      expect(described_class.new(content_item).hmrc?).to be false
    end
  end
end
