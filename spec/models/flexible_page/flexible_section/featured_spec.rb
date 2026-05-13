RSpec.describe FlexiblePage::FlexibleSection::Featured do
  subject(:featured) { described_class.new(ga4_image_card_json:, items:) }

  let(:ga4_image_card_json) { nil }
  let(:items) { [featured_document] * featured_count }
  let(:featured_count) { 6 }

  let(:featured_document) do
    {
      href: "/not-a-page",
      image: {
        alt_text: "some meaningful alt text please",
        url: "http://test.gov.uk/images/fd.png",
      },
      summary: "Summary element",
      title: "Government does things",
    }
  end

  describe "#ga4_tracking" do
    it "returns nil" do
      expect(featured.ga4_tracking).to be_nil
    end

    context "when ga4 tracking info has been supplied" do
      let(:ga4_image_card_json) do
        {
          event_name: "navigation",
          type: "image card",
          section: "Featured",
        }
      end

      it "returns ga4 tracking attributes in JSON format" do
        expect(featured.ga4_tracking).to eq({ ga4_link: "{\"event_name\":\"navigation\",\"type\":\"image card\",\"section\":\"Featured\"}", module: "ga4-link-tracker" })
      end
    end
  end

  describe "#grid_layout_options" do
    context "when there is one featured item" do
      let(:featured_count) { 1 }

      it "shows it full width" do
        expect(featured.grid_layout_options).to eq({
          class: "govuk-grid-column-full",
          break_at_column: 2,
          large: true,
        })
      end
    end

    context "when there are two featured items" do
      let(:featured_count) { 2 }

      it "shows them side by side" do
        expect(featured.grid_layout_options).to eq({
          class: "govuk-grid-column-one-half",
          break_at_column: 2,
        })
      end
    end

    context "when there are three featured items" do
      let(:featured_count) { 3 }

      it "shows them in one row" do
        expect(featured.grid_layout_options).to eq({
          class: "govuk-grid-column-one-third",
          break_at_column: 3,
        })
      end
    end

    context "when there are four featured items" do
      let(:featured_count) { 4 }

      it "shows them in two rows" do
        expect(featured.grid_layout_options).to eq({
          class: "govuk-grid-column-one-half",
          break_at_column: 2,
        })
      end
    end

    context "when there are five or more featured items" do
      let(:featured_count) { 5 }

      it "shows them in rows of three" do
        expect(featured.grid_layout_options).to eq({
          class: "govuk-grid-column-one-third",
          break_at_column: 3,
        })
      end
    end
  end
end
