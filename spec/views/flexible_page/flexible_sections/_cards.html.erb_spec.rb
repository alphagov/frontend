RSpec.describe "Cards flexible section" do
  subject(:flexible_section) { FlexiblePage::FlexibleSection::Cards.new(items:) }

  let(:items) do
    [
      {
        link: {
          text: "test1",
          path: "link1",
        },
        description: "description1",
      },
      {
        link: {
          text: "test2",
          path: "link2",
        },
        description: "description2",
      },
    ]
  end

  before do
    render(template: "flexible_page/flexible_sections/_cards", locals: { flexible_section: })
  end

  it "renders the columns section" do
    expect(rendered).to have_selector(".gem-c-cards")
  end

  it "renders individual items" do
    expect(rendered).to have_selector(".gem-c-cards__list-item .govuk-heading-s .gem-c-cards__link[href='link1']", text: "test1")
    expect(rendered).to have_selector(".gem-c-cards__list-item .govuk-body", text: "description1")
  end

  it "renders multiple items" do
    expect(rendered).to have_selector(".gem-c-cards__list-item .govuk-heading-s .gem-c-cards__link[href='link2']", text: "test2")
    expect(rendered).to have_selector(".gem-c-cards__list-item .govuk-body", text: "description2")
  end

  describe "with no input" do
    let(:items) do
      []
    end

    it "renders no items" do
      expect(rendered).not_to have_selector(".gem-c-cards")
    end
  end
end
