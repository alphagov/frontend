RSpec.describe Block::VideoCollection do
  describe "#videos" do
    it "returns an empty list if no videos are configured" do
      result = described_class.new("type" => "video_collection").videos
      expect(result).to eq([])
    end

    it "returns a list of videos" do
      result = described_class.new(
        "type" => "video_collection",
        "videos" => [
          { "title" => "Some title", "url" => "https://example.com", "date": Date.new(2024, 10, 8) },
          { "title" => "Some other title", "url" => "https://example.com", "date": Date.new(2024, 10, 8) }
        ]
      ).videos
      expect(result.map(&:title)).to eq(["Some title", "Some other title"])
    end
  end
end
