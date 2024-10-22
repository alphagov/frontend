RSpec.describe Block::DocumentList do
  let(:blocks_hash) do
    { "type" => "document_list",
      "items" => [
        { "text" => "link 1", "path" => "/a-link", "document_type" => "News article", "public_updated_at" => "2024-01-01 10:24:00" },
        { "text" => "link 2", "path" => "/another-link", "document_type" => "Press release", "public_updated_at" => "2023-01-01 10:24:00" },
      ] }
  end

  describe "#items" do
    it "returns an array of link details" do
      result = described_class.new(blocks_hash).items
      expect(result.size).to eq 2
      expect(result.first).to eq(link: { text: "link 1", path: "/a-link" }, metadata: { document_type: "News article", public_updated_at: "2024-01-01 10:24:00" })
      expect(result.second).to eq(link: { text: "link 2", path: "/another-link" }, metadata: { document_type: "Press release", public_updated_at: "2023-01-01 10:24:00" })
    end
  end
end
