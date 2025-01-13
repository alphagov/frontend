RSpec.shared_examples "it can have a contents list" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }
  let(:contents_list) { described_class.new(content_store_response) }

  it "memoises the contents to avoid repeated processing and extraction" do
    expect(contents_list).to receive(:contents_items).once

    contents_list.contents
    contents_list.contents
  end

  it "does not display contents list if body is not present" do
    content_store_response["details"]["body"] = nil

    expect(contents_list.contents).to be_empty
    expect(contents_list.contents_items.present?).to be(false)
  end

  context "when there are H2s present with ids" do
    it "includes all H2s with ids in the contents list" do
      body = Nokogiri::HTML(content_store_response["details"]["body"])
      expected_headings = body.css("h2").map do |heading|
        extract_heading(heading)
      end

      expect(contents_list.contents_items).to eq(expected_headings)
    end

    it "removes trailing colons" do
      content_store_response["details"]["body"] = "<h2 id=\"custom\">List:</h2>"

      expect(contents_list.contents_items.first).to eq({ text: "List", id: "custom" })
    end

    it "only removes trailing colons if H2s have multiple colons" do
      content_store_response["details"]["body"] = "<h2 id=\"custom\">Part 2: List:</h2>"

      expect(contents_list.contents_items.first).to eq({ text: "Part 2: List", id: "custom" })
    end
  end

  context "when there are H2s present but do not have ids" do
    it "does not display contents list" do
      content_store_response["details"]["body"] = "<h2>John Doe</h2><h2>John Doe</h2>"

      expect(contents_list.contents_items).to be_empty
    end
  end

  context "when H2s are not present" do
    it "does not display contents list" do
      html = "<p>#{Faker::Lorem.characters(number: 40)}</p>
              <ul>
                <li>#{Faker::Lorem.characters(number: 100)}</li>
                <li>#{Faker::Lorem.characters(number: 100)}</li>
                <li>#{Faker::Lorem.characters(number: 200)}</li>
              </ul>"
      content_store_response["details"]["body"] = html

      expect(contents_list.contents_items).to be_empty
    end
  end

  def extract_heading(heading)
    { text: heading.text.gsub(/:$/, ""), id: heading.attribute("id").value }
  end
end
