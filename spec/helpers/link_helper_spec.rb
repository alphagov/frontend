RSpec.describe LinkHelper do
  include described_class

  describe "#feed_link" do
    it "appends .atom to the base_path" do
      expect(feed_link("/base_path")).to eq("/base_path.atom")
    end
  end

  describe "#print_link" do
    it "appends /print to the base_path" do
      expect(print_link("/base_path")).to eq("/base_path/print")
    end
  end

  describe "#share_links" do
    let(:base_path) { "/base-path" }
    let(:title) { "My Page" }

    it "returns a facebook link" do
      link = share_links(base_path, title).select { |l| l[:text] == "Facebook" }.first

      expect(link).not_to be_nil
      expect(link[:icon]).to eq("facebook")
      expect(link[:href]).to eq("https://www.facebook.com/sharer/sharer.php?u=http%3A%2F%2Fwww.dev.gov.uk%2Fbase-path")
    end

    it "returns a twitter link" do
      link = share_links(base_path, title).select { |l| l[:text] == "Twitter" }.first

      expect(link).not_to be_nil
      expect(link[:icon]).to eq("twitter")
      expect(link[:href]).to eq("https://twitter.com/share?url=http%3A%2F%2Fwww.dev.gov.uk%2Fbase-path&text=My%20Page")
    end
  end

  describe "#govuk_styled_link" do
    let(:text) { "Some text" }
    let(:path) { "/path" }

    context "when there is no link path" do
      it "returns the text" do
        expect(govuk_styled_link(text)).to eq(text)
      end
    end

    context "when there is a link path" do
      it "returns a styled anchor element" do
        expected = "<a href='/path' class='govuk-link'>Some text</a>"

        expect(govuk_styled_link(text, path:)).to eq(expected)
      end

      it "styles the link as inverse when a inverse flag is passed" do
        expected = "<a href='/path' class='govuk-link govuk-link--inverse'>Some text</a>"

        expect(govuk_styled_link(text, path:, inverse: true)).to eq(expected)
      end
    end

    context "when the text contains special characters" do
      it "encodes special characters in the title" do
        text = "Some text & some more"
        expected = "<a href='/path' class='govuk-link'>Some text &amp; some more</a>"

        expect(govuk_styled_link(text, path:)).to eq(expected)
      end
    end
  end

  describe "#govuk_styled_links_list" do
    let(:links) do
      [
        { text: "Home", path: "/" },
        { text: "UK Trade & Investment", path: "/uk-trade-investment" },
        { text: "Foreign & Commonwealth Office", path: "/foreign-commonwealth-office" },
      ]
    end

    it "returns an array of styled links" do
      expected = [
        "<a href='/' class='govuk-link'>Home</a>",
        "<a href='/uk-trade-investment' class='govuk-link'>UK Trade &amp; Investment</a>",
        "<a href='/foreign-commonwealth-office' class='govuk-link'>Foreign &amp; Commonwealth Office</a>",
      ]

      expect(govuk_styled_links_list(links)).to eq(expected)
    end

    context "when inverse is true" do
      it "returns an array of styled links with the inverse class applied" do
        expected = [
          "<a href='/' class='govuk-link govuk-link--inverse'>Home</a>",
          "<a href='/uk-trade-investment' class='govuk-link govuk-link--inverse'>UK Trade &amp; Investment</a>",
          "<a href='/foreign-commonwealth-office' class='govuk-link govuk-link--inverse'>Foreign &amp; Commonwealth Office</a>",
        ]

        expect(govuk_styled_links_list(links, inverse: true)).to eq(expected)
      end
    end
  end
end
