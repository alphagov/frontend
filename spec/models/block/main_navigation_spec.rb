RSpec.describe Block::MainNavigation do
  let(:blocks_hash) do
    { "type" => "main_navigation",
      "title" => "Service Name",
      "title_link" => "https:/www.gov.uk",
      "links" => [
        {
          "text" => "Test 1",
          "href" => "/hello",
        },
        {
          "text" => "Test 2",
          "href" => "/goodbye",
          "items" => [
            {
              "text" => "Child a",
              "href" => "/a",
            },
            {
              "text" => "Child b",
              "href" => "/b",
            },
          ],
        },
      ] }
  end

  describe "#title" do
    it "returns a title and title_link" do
      result = described_class.new(blocks_hash)
      expect(result.title).to eq "Service Name"
      expect(result.title_link).to eq "https:/www.gov.uk"
    end
  end

  describe "#links" do
    it "returns an array of links" do
      result = described_class.new(blocks_hash).links
      expect(result.size).to eq 2
      expect(result.first).to eq({ "text" => "Test 1", "href" => "/hello" })
      expect(result.second).to eq({
        "text" => "Test 2",
        "href" => "/goodbye",
        "items" => [
          {
            "text" => "Child a",
            "href" => "/a",
          },
          {
            "text" => "Child b",
            "href" => "/b",
          },
        ],
      })
    end
  end

  describe "#full_width?" do
    it "is true" do
      expect(described_class.new(blocks_hash).full_width?).to eq(true)
    end
  end
end
