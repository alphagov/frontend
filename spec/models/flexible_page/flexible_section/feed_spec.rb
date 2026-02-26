RSpec.describe FlexiblePage::FlexibleSection::Feed do
  subject(:content_hash) do
    {
      "feed_heading_text" => "Test Heading",
      "email_signup_link" => "/test-link",
      "items" => [
        { "link" => { "text" => "item 1", "path" => "/item-1" }, "metadata" => { "public_updated_at" => "2025-10-31 10:00:00 +0000", "document_type" => "Example guidance", "display_type" => "guidance", "description" => "What's up?" } },
        { "link" => { "text" => "item 2", "path" => "/item-2" }, "metadata" => { "public_updated_at" => "2025-10-31 10:00:00 +0000", "document_type" => "Example guidance", "display_type" => "guidance", "description" => "What's up?" } },
      ],
      "see_all_items_link" => "/test-see-all",
      "share_links_heading_text" => "share links",
      "share_links" => [
        { "href" => "/blue-sky", "text" => "Blue Sky", "icon" => "bluesky", "data_attributes" => { "module": "example" } },
      ],
    }
  end

  let(:feed) { described_class.new(content_hash, FlexiblePage.new({})) }

  describe "#initialize" do
    it "sets the attributes from the feed hash" do
      expect(feed.feed_heading_text).to eq("Test Heading")
      expect(feed.email_signup_link).to eq("/test-link")
      expect(feed.items).to eq([
        { link: { text: "item 1", path: "/item-1" }, metadata: { public_updated_at: "2025-10-31 10:00:00.000000000 +00:00", document_type: "Example guidance", display_type: "guidance", description: "What's up?" } },
        { link: { text: "item 2", path: "/item-2" }, metadata: { public_updated_at: "2025-10-31 10:00:00.000000000 +00:00", document_type: "Example guidance", display_type: "guidance", description: "What's up?" } },
      ])
      expect(feed.see_all_items_link).to eq("/test-see-all")
      expect(feed.share_links_heading_text).to eq("share links")
      expect(feed.share_links).to eq([{ "data_attributes" => { module: "example" },
                                        "href" => "/blue-sky",
                                        "icon" => "bluesky",
                                        "text" => "Blue Sky" }])
    end
  end
end
