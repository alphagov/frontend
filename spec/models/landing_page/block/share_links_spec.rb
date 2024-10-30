RSpec.describe LandingPage::Block::ShareLinks do
  let(:blocks_hash) do
    {
      "type" => "share_links",
      "links" => [
        {
          "href" => "/twitter-profile",
          "text" => "Twitter",
          "icon" => "twitter",
          "hidden_text" => "Follow us on",
        },
        {
          "href" => "/instagram-profile",
          "text" => "Instagram",
          "icon" => "instagram",
          "hidden_text" => "Follow us on",
        },
      ],
    }
  end

  it "returns all of the side navigation links" do
    links = described_class.new(blocks_hash).links
    expect(links.count).to eq(2)
    expect(links.first[:text]).to eq("Twitter")
    expect(links.first[:href]).to eq("/twitter-profile")
    expect(links.first[:icon]).to eq("twitter")
    expect(links.first[:hidden_text]).to eq("Follow us on")
  end
end
