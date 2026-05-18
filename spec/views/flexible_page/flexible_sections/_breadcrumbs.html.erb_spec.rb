RSpec.describe "Breadcrumbs flexible section" do
  subject(:flexible_section) { FlexiblePage::FlexibleSection::Breadcrumbs.new(breadcrumbs: breadcrumb_params) }

  let(:breadcrumb_params) do
    [
      {
        title: "History of the UK Government",
        url: "/government/history",
      },
    ]
  end

  before do
    render(template: "flexible_page/flexible_sections/_breadcrumbs", locals: { flexible_section: })
  end

  it "renders breadcrumbs section" do
    expect(rendered).to have_selector("[data-flexible-section='breadcrumbs']")
  end

  it "renders a breadcrumb component" do
    expect(rendered).to have_selector(".gem-c-breadcrumbs")
    expect(rendered).to have_link("History of the UK Government", href: "/government/history")
  end
end
