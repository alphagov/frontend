RSpec.shared_examples "it has parts" do |document_type, example_name|
  before do
    @content_store_response = GovukSchemas::Example.find(document_type, example_name:)
    @part_slug = @content_store_response.dig("details", "parts").last["slug"]
  end

  it "gets all parts" do
    expected_parts_count = @content_store_response.dig("details", "parts").count
    expect(described_class.new(@content_store_response).parts.count).to eq(expected_parts_count)
  end

  it "gets the current part title" do
    content_item = described_class.new(@content_store_response)
    content_item.set_current_part(@part_slug)
    expected_title = @content_store_response.dig("details", "parts").last["title"]

    expect(content_item.current_part_title).to eq(expected_title)
  end

  it "gets the current part body" do
    content_item = described_class.new(@content_store_response)
    content_item.set_current_part(@part_slug)
    expected_body = @content_store_response.dig("details", "parts").last["body"]

    expect(content_item.current_part_body).to eq(expected_body)
  end

  it "gets the next part" do
    content_item = described_class.new(@content_store_response)
    part_slug = @content_store_response.dig("details", "parts").first["slug"]
    content_item.set_current_part(part_slug)

    expect(content_item.next_part["slug"]).not_to eq(part_slug)
  end

  it "gets the previous part" do
    content_item = described_class.new(@content_store_response)
    content_item.set_current_part(@part_slug)

    expect(content_item.previous_part["slug"]).not_to eq(@part_slug)
  end

  describe "#first_part?" do
    it "returns true if the current part is the first part" do
      content_item = described_class.new(@content_store_response)
      part_slug = @content_store_response.dig("details", "parts").first["slug"]
      content_item.set_current_part(part_slug)

      expect(content_item.first_part?).to be true
    end

    it "returns false if the current part is the first part" do
      content_item = described_class.new(@content_store_response)
      content_item.set_current_part(@part_slug)

      expect(content_item.first_part?).to be false
    end
  end
end
