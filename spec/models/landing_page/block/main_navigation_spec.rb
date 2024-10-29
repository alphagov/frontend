RSpec.describe LandingPage::Block::MainNavigation do
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
  let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }

  describe "#title" do
    it "returns a title and title_link" do
      expect(subject.title).to eq "Service Name"
      expect(subject.title_link).to eq "https:/www.gov.uk"
    end
  end

  describe "#links" do
    it "returns an array of links" do
      expect(subject.links.size).to eq 2
      expect(subject.links.first).to eq({ "text" => "Test 1", "href" => "/hello" })
      expect(subject.links.second).to eq({
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
      expect(subject.full_width?).to eq(true)
    end
  end
end
