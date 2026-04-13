RSpec.describe "Table flexible section" do
  let(:flexible_section) { FlexiblePage::FlexibleSection::Table.new({ "data" => data }, nil) }
  let(:data) do
    {
      head: [
        {
          text: "Year",
        },
        {
          text: "Value",
          format: "numeric",
        },
      ],
      rows: [
        [
          {
            text: "2025",
          },
          {
            text: "5",
            format: "numeric",
          },
        ],
        [
          {
            text: "2026",
          },
          {
            text: "6",
            format: "numeric",
          },
        ],
      ],
    }
  end

  before do
    render(template: "flexible_page/flexible_sections/_table", locals: { flexible_section: })
  end

  it "renders link section" do
    expect(rendered).to have_selector("[data-flexible-section='table']")
  end

  it "renders the table component with the data" do
    expect(rendered).to have_selector(".govuk-table__header", text: "Year")
    expect(rendered).to have_selector(".govuk-table__cell", text: "2025")
  end

  context "when a caption is provided" do
    let(:flexible_section) { FlexiblePage::FlexibleSection::Table.new({ "caption" => "Table Caption", "data" => data }, nil) }

    it "renders the caption" do
      expect(rendered).to have_selector(".govuk-table__caption", text: "Table Caption")
    end
  end
end
