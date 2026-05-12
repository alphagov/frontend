RSpec.describe "ContentThenSidebarLayout flexible section" do
  subject(:flexible_section) { FlexiblePage::FlexibleSection::ContentThenSidebarLayout.new(content:, sidebar:) }

  let(:content) { FlexiblePage::FlexibleSection::Link.new(link: "/a", link_text: "Link A") }
  let(:sidebar) { FlexiblePage::FlexibleSection::Link.new(link: "/b", link_text: "Link B") }

  before do
    render(template: "flexible_page/flexible_sections/_content_then_sidebar_layout", locals: { flexible_section: })
  end

  it "renders 2 columns then 1 column" do
    expect(rendered).to have_selector(".govuk-grid-column-two-thirds + .govuk-grid-column-one-third")
  end

  it "renders the content in 2 columns" do
    expect(rendered).to have_selector(".govuk-grid-column-two-thirds a[href='/a']")
  end

  it "renders the sidebar in 1 column" do
    expect(rendered).to have_selector(".govuk-grid-column-one-third a[href='/b']")
  end
end
