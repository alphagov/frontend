RSpec.describe LandingPage::Block::ShareLinks do
  let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }
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

  it_behaves_like "it is a landing-page block"

  it "returns all of the side navigation links" do
    expect(subject.links.count).to eq(2)
    expect(subject.links.first[:text]).to eq("Twitter")
    expect(subject.links.first[:href]).to eq("/twitter-profile")
    expect(subject.links.first[:icon]).to eq("twitter")
    expect(subject.links.first[:hidden_text]).to eq("Follow us on")
  end
end
