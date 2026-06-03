RSpec.describe "Cards flexible section" do
  subject(:flexible_section) { FlexiblePage::FlexibleSection::Cards.new(items:, heading_level:) }

  let(:heading_level) { nil }
  let(:items) do
    [
      {
        title: "test1",
        href: "link1",
        description: "description1",
      },
      {
        title: "test2",
        href: "link2",
        description: "description2",
      },
    ]
  end

  before do
    render(template: "flexible_page/flexible_sections/_cards", locals: { flexible_section: })
  end

  it "renders the columns section" do
    expect(rendered).to have_selector("[data-flexible-section='cards']")
    expect(rendered).to have_selector(".cards .cards__container")
  end

  it "renders individual items" do
    expect(rendered).to have_selector(".cards__item h2.cards__item-header .cards__link[href='link1']", text: "test1")
    expect(rendered).to have_selector(".cards__item .govuk-body", text: "description1")
  end

  it "renders multiple items" do
    expect(rendered).to have_selector(".cards__item h2.cards__item-header .cards__link[href='link2']", text: "test2")
    expect(rendered).to have_selector(".cards__item .govuk-body", text: "description2")
  end

  describe "with no input" do
    let(:items) do
      []
    end

    it "renders no items" do
      expect(rendered).not_to have_selector(".cards__container .cards__item")
    end
  end

  describe "with a custom heading level" do
    let(:heading_level) { 3 }

    it "sets the heading level correctly" do
      expect(rendered).to have_selector("h3.cards__item-header", text: "test1")
    end
  end
end
