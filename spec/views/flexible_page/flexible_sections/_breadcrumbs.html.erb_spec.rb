RSpec.describe "Breadcrumbs flexible section" do
  subject(:flexible_section) { FlexiblePage::FlexibleSection::Breadcrumbs.new(breadcrumbs_options:, full_width:, background:) }

  let(:breadcrumb_params) do
    [
      {
        title: "History of the UK Government",
        url: "/government/history",
      },
    ]
  end
  let(:breadcrumbs_options) do
    { breadcrumbs: breadcrumb_params }
  end
  let(:full_width) { nil }
  let(:background) { nil }

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

  describe "margin bottom" do
    let(:breadcrumbs_options) do
      {
        breadcrumbs: breadcrumb_params,
        margin_bottom: 2,
      }
    end

    it "sets the margin_bottom of the breadcrumbs component" do
      expect(rendered).to have_selector(".gem-c-breadcrumbs.govuk-\\!-margin-bottom-2")
    end
  end

  describe "full width" do
    let(:full_width) { true }

    it "sets the flexible section to be full width" do
      expect(rendered).to have_selector(".full-width__element")
    end
  end

  describe "background" do
    let(:background) { true }

    it "sets the flexible section to be full width" do
      expect(rendered).to have_selector(".breadcrumbs--dark-background")
    end
  end
end
