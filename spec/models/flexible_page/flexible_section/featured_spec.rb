RSpec.describe FlexiblePage::FlexibleSection::Featured do
  featured_item = {
    href: "/href",
    image_src: "/img/src.jpg",
    image_alt: "some meaningful alt text please",
    heading_text: "Government does things",
    description: "This a description",
  }

  subject(:content_hash) do
    {
      "items" => [featured_item],
    }
  end

  let(:featured) { described_class.new(content_hash, FlexiblePage.new({})) }

  describe "when there is one featured item" do
    it "shows it full width" do
      expect(featured.grid_layout_options).to eq({
        class: "govuk-grid-column-full",
        break_at_column: 2,
        large: true,
      })
    end
  end

  describe "when there are two featured items" do
    let(:content_hash) do
      {
        "items" => [featured_item, featured_item],
      }
    end

    it "shows them side by side" do
      expect(featured.grid_layout_options).to eq({
        class: "govuk-grid-column-one-half",
        break_at_column: 2,
      })
    end
  end

  describe "when there are three featured items" do
    let(:content_hash) do
      {
        "items" => [featured_item, featured_item, featured_item],
      }
    end

    it "shows them in one row" do
      expect(featured.grid_layout_options).to eq({
        class: "govuk-grid-column-one-third",
        break_at_column: 3,
      })
    end
  end

  describe "when there are four featured items" do
    let(:content_hash) do
      {
        "items" => [featured_item, featured_item, featured_item, featured_item],
      }
    end

    it "shows them in two rows" do
      expect(featured.grid_layout_options).to eq({
        class: "govuk-grid-column-one-half",
        break_at_column: 2,
      })
    end
  end

  describe "when there are five featured items" do
    let(:content_hash) do
      {
        "items" => [featured_item, featured_item, featured_item, featured_item, featured_item],
      }
    end

    it "shows them in rows of three" do
      expect(featured.grid_layout_options).to eq({
        class: "govuk-grid-column-one-third",
        break_at_column: 3,
      })
    end
  end
end
