RSpec.describe "Link flexible section" do
  subject(:flexible_section) { FlexiblePage::FlexibleSection::Link.new(link: "/about", link_text: "About page") }

  before do
    render(template: "flexible_page/flexible_sections/_link", locals: { flexible_section: })
  end

  it "renders link section" do
    expect(rendered).to have_selector("[data-flexible-section='link']")
  end

  it "renders the link" do
    expect(rendered).to have_link("About page", href: "/about")
  end
end
