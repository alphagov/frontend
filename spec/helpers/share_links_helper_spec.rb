RSpec.describe ShareLinksHelper do
  include described_class

  describe "#share_links" do
    let(:title) { "A title with - a hyphen" }

    it "encodes the url and title correctly" do
      allow(self).to receive(:request).and_return(ActionDispatch::TestRequest.new("PATH_INFO" => "/a/base/path"))
      expected_path = url_encode(Plek.new.website_root + request.path)

      expected_share_links = [
        {
          href: "https://www.facebook.com/sharer/sharer.php?u=#{expected_path}",
          text: "Facebook",
          icon: "facebook",
        },
        {
          href: "https://twitter.com/share?url=#{expected_path}&text=#{url_encode(title)}",
          text: "Twitter",
          icon: "twitter",
        },
      ]

      expect(share_links(title)).to eq(expected_share_links)
    end
  end
end
