RSpec.describe "Featured flexible section" do
  let(:flexible_section) { FlexiblePage::FlexibleSection::Featured.new(section_hash, nil) }
  let(:section_hash) do
    {
      "ordered_featured_documents" => ([featured_document] * featured_count),
      "ga4_image_card_json" => ga4_image_card_json,
    }
  end

  let(:featured_document) do
    {
      "href" => "/not-a-page",
      "image" => {
        "alt_text" => "some meaningful alt text please",
        "url" => "http://test.gov.uk/images/fd.png",
      },
      "summary" => summary,
      "title" => "Government does things",
    }
  end

  let(:featured_count) { 6 }
  let(:summary) { "This is a summary" }
  let(:ga4_image_card_json) { nil }

  before do
    render(template: "flexible_page/flexible_sections/_featured", locals: { flexible_section: })
  end

  describe "featured items" do
    it "contains the basic expected elements" do
      expect(rendered).to have_selector(".gem-c-heading", text: "Featured")
      expect(rendered).to have_selector(".govuk-grid-column-one-third .gem-c-image-card .gem-c-image-card__description", text: "This is a summary")
    end

    context "when there's only 1 featured item" do
      let(:featured_count) { 1 }

      it "renders it as large" do
        expect(rendered).to have_selector(".govuk-grid-column-full .gem-c-image-card.gem-c-image-card--large", count: 1)
      end
    end

    context "when there's only 2 featured items" do
      let(:featured_count) { 2 }

      it "renders them side-by-side" do
        expect(rendered).to have_selector(".govuk-grid-row", count: 1)
        expect(rendered).to have_selector(".govuk-grid-column-one-half .gem-c-image-card", count: 2)
        expect(rendered).not_to have_selector(".gem-c-image-card--large")
      end
    end

    context "when there's 3 featured items" do
      let(:featured_count) { 3 }

      it "renders them in a row" do
        expect(rendered).to have_selector(".govuk-grid-row", count: 1)
        expect(rendered).to have_selector(".govuk-grid-column-one-third .gem-c-image-card", count: 3)
        expect(rendered).not_to have_selector(".gem-c-image-card--large")
      end
    end

    context "when there's 4 featured items" do
      let(:featured_count) { 4 }

      it "renders them in two rows" do
        expect(rendered).to have_selector(".govuk-grid-row", count: 2)
        expect(rendered).to have_selector(".govuk-grid-column-one-half .gem-c-image-card", count: 4)
        expect(rendered).not_to have_selector(".gem-c-image-card--large")
      end
    end

    context "when there's 5 featured items" do
      let(:featured_count) { 5 }

      it "renders them in two rows" do
        expect(rendered).to have_selector(".govuk-grid-row", count: 2)
        expect(rendered).to have_selector(".govuk-grid-column-one-third .gem-c-image-card", count: 5)
        expect(rendered).not_to have_selector(".gem-c-image-card--large")
      end
    end

    context "when a description is very long" do
      let(:summary) { "This summary is very long, and it will need to be truncated at an appropriate place otherwise it will appear too long in the featured cards and they'll be a bit visually unbalanced." }

      it "truncates the summary to below 160 chars" do
        expect(rendered).to have_selector(
          ".govuk-grid-column-one-third .gem-c-image-card .gem-c-image-card__description",
          text: "This summary is very long, and it will need to be truncated at an appropriate place otherwise it will appear too long in the featured cards and they'll be a...",
        )
      end
    end

    context "when GA4 tracking is not included" do
      let(:ga4_image_card_json) { nil }

      it "has no tracking by default" do
        expect(rendered).not_to have_selector("[data-module=ga4-link-tracker]")
      end
    end

    context "when GA4 tracking is included" do
      let(:ga4_image_card_json) do
        {
          "event_name": "navigation",
          "type": "image card",
          "section": "Featured",
        }
      end

      it "has tracking" do
        expect(rendered).to have_selector("[data-module=ga4-link-tracker]")
        expect(rendered).to have_selector("[data-ga4-link='{\"event_name\":\"navigation\",\"type\":\"image card\",\"section\":\"Featured\"}']")
      end
    end
  end
end
