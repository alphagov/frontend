RSpec.describe LandingPage::Block::PressNotices do
  let(:blocks_hash) do
    { "type" => "press_notices",
      "items" => [
        { "text" => "link 1", "href" => "/a-link", "document_type" => "Press release", "public_updated_at" => "2024-01-01 10:24:00" },
        { "text" => "link 2", "href" => "/another-link", "document_type" => "Press release", "public_updated_at" => "2023-01-01 10:24:00" },
      ] }
  end

  describe "#items" do
    it "doesn't error if nothing found" do
      result = described_class.new({}, build(:landing_page)).items
      expect(result.size).to eq 0
    end

    it "returns an array of link details" do
      result = described_class.new(blocks_hash, build(:landing_page)).items
      expect(result.size).to eq 2
      expect(result.first).to eq(link: { text: "link 1", path: "/a-link" }, metadata: { document_type: "Press release", public_updated_at: "2024-01-01 10:24:00" })
      expect(result.second).to eq(link: { text: "link 2", path: "/another-link" }, metadata: { document_type: "Press release", public_updated_at: "2023-01-01 10:24:00" })
    end
  end
end
