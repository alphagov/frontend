RSpec.describe "Govspeak flexible section" do
  let(:flexible_section) { FlexiblePage::FlexibleSection::Govspeak.new(govspeak: "<h2>Introduction</h2><p>Hello to this section</p>") }

  before do
    render(template: "flexible_page/flexible_sections/_govspeak", locals: { flexible_section: })
  end

  it "renders govspeak" do
    expect(rendered).to have_selector(".govuk-govspeak h2", text: "Introduction")
    expect(rendered).to have_text("Hello to this section")
  end
end
