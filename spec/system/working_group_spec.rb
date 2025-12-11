RSpec.describe "Working Group" do
  context "when visiting a working group page" do
    let(:content_item) { GovukSchemas::Example.find(:working_group, example_name: "long") }
    let(:base_path) { content_item["base_path"] }

    before do
      stub_content_store_has_item(base_path, content_item)
      visit base_path
    end

    it "has a title" do
      expect(page).to have_title(content_item["title"])
    end

    it "includes the description" do
      expect(page).to have_text(content_item["description"])
    end

    it "includes contact details" do
      expect(page).to have_selector("h2#contact-details")
      expect(page).to have_text("Contact details")
      expect(page).to have_text(content_item["details"]["email"])
    end

    it "includes a contents list" do
      expect(page).to have_contents_list([
        { text: "Membership",         id: "membership" },
        { text: "Terms of reference", id: "terms-of-reference" },
        { text: "Meeting minutes",    id: "meeting-minutes" },
        { text: "Contact details",    id: "contact-details" },
      ])
    end
  end
end

# test "working groups" do
#   assert page.has_text?("Benefits and Credits Consultation Group meeting 28 May 2014")
# end

# test "with_policies" do
#   setup_and_visit_content_item("with_policies")

#   policy = @content_item["links"]["policies"][0]
#   assert page.has_text?("Policies")
#   assert page.has_text?(policy["title"])

#   assert page.has_css?("h2#policies")
# end

# test "with a body that has no h2s" do
#   item = get_content_example("short")
#   item["details"]["body"] = "<div class='govspeak'><p>Some content<p></div>"
#   stub_content_store_has_item(item["base_path"], item.to_json)
#   visit(item["base_path"])

#   assert page.has_text?("Some content")
# end

# test "renders a content list" do
#   setup_and_visit_content_item("with_policies")
#   assert page.has_css?(".gem-c-contents-list", text: "Contents")
# end
