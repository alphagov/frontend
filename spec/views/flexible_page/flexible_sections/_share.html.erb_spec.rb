RSpec.describe "Share flexible section" do
  subject(:flexible_section) { FlexiblePage::FlexibleSection::Share.new(heading_text:, links:) }

  let(:heading_text) { "Follow us" }
  let(:links) do
    [
      {
        href: "https://twitter.com/foreignoffice",
        icon: "twitter",
        text: "Twitter",
      },
    ]
  end

  before do
    render(template: "flexible_page/flexible_sections/_share", locals: { flexible_section: })
  end

  describe "share links" do
    it "shows the share links title" do
      expect(rendered).to have_selector("h2", text: "Follow us")
    end

    it "shows the new tab warning" do
      expect(rendered).to have_selector("p.govuk-body-s", text: "The following links open in a new tab")
    end

    it "shows the share links list" do
      expect(rendered).to have_selector("ul.gem-c-share-links__list")
    end

    it "shows the share link items" do
      expect(rendered).to have_link("Twitter", href: "https://twitter.com/foreignoffice")
      expect(rendered).to have_selector(".gem-c-share-links__link-icon .gem-c-share-links__svg")
    end
  end
end
