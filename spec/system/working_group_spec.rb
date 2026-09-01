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

    it "includes body text" do
      expect(page).to have_text("Benefits and Credits Consultation Group meeting 28 May 2014")
    end

    context "when policy links are present" do
      let(:content_item) { GovukSchemas::Example.find(:working_group, example_name: "with_policies") }

      it "displays a policies header" do
        expect(page).to have_text("Policies")
        expect(page).to have_selector("h2#policies")
      end

      it "displays the policies" do
        expect(page).to have_text(content_item["links"]["policies"][0]["title"])
      end

      it "includes policies in the contents list" do
        expect(page).to have_contents_list([
          { text: "Contact details",    id: "contact-details" },
          { text: "Policies",           id: "policies" },
        ])
      end
    end

    context "with a body that has no h2s" do
      let(:content_item) do
        GovukSchemas::Example.find(:working_group, example_name: "short").tap do |item|
          item["details"]["body"] = "<div class='govspeak'><p>Some content<p></div>"
        end
      end

      it "displays the content" do
        expect(page).to have_text("Some content")
      end
    end
  end
end
