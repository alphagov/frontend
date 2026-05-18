RSpec.describe FlexiblePage::FlexibleSection::DocumentList do
  subject(:document_list) { described_class.new(email_signup_link:, email_signup_link_text:, heading_text:, items:, see_all_items_link:, see_all_items_link_text:) }

  let(:email_signup_link) { "/email/get" }
  let(:email_signup_link_text) { "Get emails" }
  let(:heading_text) { "Latest" }
  let(:items) do
    [
      { link: { text: "item 1", path: "/item-1" }, metadata: { public_updated_at: Time.zone.parse("2025-10-31 10:00:00 +0000"), document_type: "Example guidance", display_type: "guidance", description: "What's up?" } },
      { link: { text: "item 2", path: "/item-2" }, metadata: { public_updated_at: Time.zone.parse("2025-10-31 10:00:00 +0000"), document_type: "Example guidance", display_type: "guidance", description: "What's up?" } },
    ]
  end
  let(:see_all_items_link) { "/test-see-all" }
  let(:see_all_items_link_text) { "See all updates" }

  describe "#initialize" do
    it "sets the attributes from the feed hash" do
      expect(document_list.email_signup_link).to eq("/email/get")
      expect(document_list.email_signup_link_text).to eq("Get emails")
      expect(document_list.heading_text).to eq("Latest")
      expect(document_list.see_all_items_link).to eq("/test-see-all")
      expect(document_list.see_all_items_link_text).to eq("See all updates")
    end
  end

  describe "#items" do
    it "returns the passed items, removing unneeded metadata and parsing times" do
      expect(document_list.items).to eq([
        { link: { text: "item 1", path: "/item-1" }, metadata: { public_updated_at: "2025-10-31 10:00:00.000000000 +00:00", document_type: "Example guidance" } },
        { link: { text: "item 2", path: "/item-2" }, metadata: { public_updated_at: "2025-10-31 10:00:00.000000000 +00:00", document_type: "Example guidance" } },
      ])
    end
  end
end
