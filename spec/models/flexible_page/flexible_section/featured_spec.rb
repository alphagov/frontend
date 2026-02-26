RSpec.describe FlexiblePage::FlexibleSection::Featured do
  featured_item = {
    "href" => "/href",
    "image" => {
      "url" => "/img/src.jpg",
      "alt_text" => "some meaningful alt text please",
    },
    "title" => "Government does things",
    "summary" => "This a description",
  }

  subject(:content_hash) do
    {
      "ordered_featured_documents" => [featured_item],
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
        "ordered_featured_documents" => [featured_item, featured_item],
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
        "ordered_featured_documents" => [featured_item, featured_item, featured_item],
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
        "ordered_featured_documents" => [featured_item, featured_item, featured_item, featured_item],
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
        "ordered_featured_documents" => [featured_item, featured_item, featured_item, featured_item, featured_item],
      }
    end

    it "shows them in rows of three" do
      expect(featured.grid_layout_options).to eq({
        class: "govuk-grid-column-one-third",
        break_at_column: 3,
      })
    end
  end

  describe "when a featured item receives govspeak in the summary" do
    let(:content_hash) do
      {
        "ordered_featured_documents" => [
          {
            "href" => "/href",
            "image" => {
              "url" => "/img/src.jpg",
              "alt_text" => "some meaningful alt text please",
            },
            "title" => "Government does things",
            "summary" => "<p>This a description with <strong>HTML</strong> in it.</p>",
          },
        ],
      }
    end

    it "sanitises the HTML from the summary" do
      expect(featured.items.first[:description]).to eq("This a description with HTML in it.")
    end
  end
end
