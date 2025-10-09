RSpec.shared_examples "it can have manual title" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it has manual title" do
    expect(described_class.new(content_item).title).to eq(content_item.dig("links", "manual").first["title"])
  end
end

RSpec.shared_examples "it can have page title" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it has page title" do
    expect(described_class.new(content_item).page_title).to eq("Content design: planning, writing and managing content - What is content design? - Guidance")
  end
end

RSpec.shared_examples "it can have document heading" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it has document heading" do
    expect(described_class.new(content_item).document_heading).to eq(["What is content design?"])
  end
end

RSpec.shared_examples "it can have breadcrumbs" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it has breadcrumbs" do
    expect(described_class.new(content_item).breadcrumbs).to eq([{ title: "Back to contents", url: "/guidance/content-design/what-is-content-design" }])
  end
end
