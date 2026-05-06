RSpec.describe "DocumentList flexible section" do
  subject(:flexible_section) do
    FlexiblePage::FlexibleSection::DocumentList.new(
      email_signup_link:, email_signup_link_text:, heading_text:, items:, see_all_items_link:, see_all_items_link_text:,
    )
  end

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
  let(:see_all_items_link_text) { "See more updates" }

  before do
    render(template: "flexible_page/flexible_sections/_document_list", locals: { flexible_section: })
  end

  it "shows a heading over the document list" do
    expect(rendered).to have_selector("h2", text: "Latest")
  end

  it "shows the document list with documents" do
    expect(rendered).to have_selector("ul.gem-c-document-list")

    expect(rendered).to have_link("item 1", href: "/item-1")
    expect(rendered).to have_selector(".gem-c-document-list__item-metadata time", text: "31 October 2025")
    expect(rendered).to have_selector(".gem-c-document-list__item-metadata .gem-c-document-list__attribute", text: "Example guidance")
  end

  it "shows a see all link" do
    expect(rendered).to have_link("See more updates", href: "/test-see-all")
  end

  it "has ga4 tracking on the see all link" do
    ga4_link_data = JSON.parse(rendered.html.css("ul + p").first["data-ga4-link"])

    expect(ga4_link_data).to eq({ "event_name" => "navigation", "type" => "see all", "section" => "Latest" })
  end

  it "has a subscription link" do
    expect(rendered).to have_link("Get emails", href: "/email/get")
  end

  it "has ga4 tracking on the subscription link" do
    ga4_link_data = JSON.parse(rendered.html.css(".gem-c-subscription-links").first["data-ga4-link"])

    expect(ga4_link_data).to eq({ "event_name" => "navigation", "type" => "subscribe", "index_link" => 1, "index_total" => 1, "section" => "Latest" })
  end
end
