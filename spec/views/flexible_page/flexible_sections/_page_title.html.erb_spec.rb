RSpec.describe "Page title flexible section" do
  subject(:flexible_section) { FlexiblePage::FlexibleSection::PageTitle.new(context:, heading_text:, lead_paragraph:) }

  let(:context) { "History" }
  let(:heading_text) { "10 Downing Street" }
  let(:lead_paragraph) { "History of 10 Downing Street, Westminster" }

  before do
    render(template: "flexible_page/flexible_sections/_page_title", locals: { flexible_section: })
  end

  it "renders the page title component" do
    expect(rendered).to have_selector("h1", text: "10 Downing Street")
  end

  it "renders the context" do
    expect(rendered).to have_text("History")
  end

  it "renders the lead paragraph" do
    expect(rendered).to have_text("History of 10 Downing Street, Westminster")
  end
end
