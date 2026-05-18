RSpec.describe "Rich contents list flexible section" do
  subject(:flexible_section) { FlexiblePage::FlexibleSection::RichContentsList.new(contents_list:, image:) }

  let(:contents_list) do
    [
      { id: "introduction", text: "Introduction" },
      { id: "take_tour", text: "Take the tour" },
    ]
  end
  let(:image) { nil }

  before do
    render(template: "flexible_page/flexible_sections/_rich_contents_list", locals: { flexible_section: })
  end

  it "renders the contents list" do
    expect(rendered).to have_selector("h2.gem-c-contents-list__title", text: "Contents")
    expect(rendered).to have_selector("ol.gem-c-contents-list__list li", text: "Introduction")
    expect(rendered).to have_selector("ol.gem-c-contents-list__list li", text: "Take the tour")
  end

  context "with an image" do
    let(:image) do
      {
        alt: "Picture of No. 10",
        src: "https://example.gov.uk/no10.jpg",
      }
    end

    it "renders the image" do
      expect(rendered).to have_selector("img[src='https://example.gov.uk/no10.jpg']")
    end
  end
end
