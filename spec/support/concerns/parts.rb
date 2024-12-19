RSpec.shared_examples "it has parts" do |document_type, example_name|
  subject(:content_item_with_parts) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }
  let(:part_slug) { content_store_response.dig("details", "parts").last["slug"] }

  it "gets all parts" do
    expected_parts_count = content_store_response.dig("details", "parts").count
    expect(content_item_with_parts.parts.count).to eq(expected_parts_count)
  end

  it "gets the current part title" do
    content_item_with_parts.set_current_part(part_slug)
    expected_title = content_store_response.dig("details", "parts").last["title"]

    expect(content_item_with_parts.current_part_title).to eq(expected_title)
  end

  it "gets the current part body" do
    content_item_with_parts.set_current_part(part_slug)
    expected_body = content_store_response.dig("details", "parts").last["body"]

    expect(content_item_with_parts.current_part_body).to eq(expected_body)
  end

  it "gets the next part" do
    first_part_slug = content_store_response.dig("details", "parts").first["slug"]
    content_item_with_parts.set_current_part(first_part_slug)

    expect(content_item_with_parts.next_part["slug"]).not_to eq(first_part_slug)
  end

  it "gets the previous part" do
    content_item_with_parts.set_current_part(part_slug)

    expect(content_item_with_parts.previous_part["slug"]).not_to eq(part_slug)
  end

  describe "#first_part?" do
    it "returns true if the current part is the first part" do
      first_part_slug = content_store_response.dig("details", "parts").first["slug"]
      content_item_with_parts.set_current_part(first_part_slug)

      expect(content_item_with_parts.first_part?).to be true
    end

    it "returns false if the current part is the first part" do
      content_item_with_parts.set_current_part(part_slug)

      expect(content_item_with_parts.first_part?).to be false
    end
  end
end
