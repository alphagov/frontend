RSpec.describe "HTML publication" do
  describe "GET /<document_type>/<slug>" do
    let(:content_item) { GovukSchemas::Example.find(:html_publication, example_name: "published") }
    let(:base_path) { content_item["base_path"] }

    before do
      stub_content_store_has_item(base_path, content_item)
      parent_path = content_item["links"]["parent"].first["base_path"]
      stub_content_store_has_item(parent_path, GovukSchemas::Example.find("publication", example_name: "publication"))

      visit base_path
    end

    describe "when visiting a html publication" do
      it "has expected elements and contents" do
        visit base_path

        within ".gem-c-inverse-header" do
          format_sub_type = content_item["details"]["format_sub_type"]
          expect(page).to have_text(format_sub_type) if format_sub_type.present?
          expect(page).to have_text(content_item["title"])

          expect(page).to have_text("Published 17 January 2016")
        end

        within "#contents" do
          expect(page).to have_text("Contents")
          expect(page).to have_css(".gem-c-contents-list")
        end

        expect(page).to have_text("The Environment Agency will normally put any responses it receives on the public register. This includes your name and contact details. Tell us if you don’t want your response to be public.")
      end

      it "renders back to contents elements" do
        expect(page).to have_css(".gem-c-back-to-top-link[href='#contents']")
      end
    end

    describe "when visiting a html publication with metadata" do
      let(:content_item) { GovukSchemas::Example.find(:html_publication, example_name: "print_with_meta_data") }

      it "has meta data" do
        within ".print-metadata" do
          expect(page).to have_text("© Crown copyright #{content_item['details']['public_timestamp'].to_date.year}")
          expect(page).to have_text("ISBN: #{content_item['details']['isbn']}")
        end
      end
    end

    describe "a prime minister office organisation html publication" do
      let(:content_item) { GovukSchemas::Example.find(:html_publication, example_name: "prime_ministers_office") }

      it "has the right organisation logo" do
        within(".organisation-logos__logo:nth-of-type(4)") do
          expect(page).to have_css(".gem-c-organisation-logo.brand--cabinet-office")
        end
      end

      it "shows no contents when headings are an empty list" do
        within ".gem-c-inverse-header" do
          expect(page).not_to have_text("Contents")
        end
      end
    end

    describe "an historically political html publication" do
      let(:content_item) { GovukSchemas::Example.find(:html_publication, example_name: "published_with_history_mode") }

      it "describes the relevant government" do
        within ".govuk-notification-banner__content" do
          expect(page).to have_text("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
        end
      end
    end

    describe "a withdrawn html publication" do
      let(:content_item) do
        GovukSchemas::Example.find(:html_publication, example_name: "prime_ministers_office").tap do |example|
          example["withdrawn_notice"] = {
            'explanation': "This is out of date",
            'withdrawn_at': "2014-08-09T11:39:05Z",
          }
        end
      end

      it "shows withdrawn details" do
        expect(page).to have_css(".gem-c-notice__title", text: "This policy paper was withdrawn on 9 August 2014")
        expect(page).to have_css(".gem-c-notice", text: "This is out of date")
      end
    end

    describe "a withdrawn publication with no parent document_type" do
      let(:content_item) do
        GovukSchemas::Example.find(:html_publication, example_name: "prime_ministers_office").tap do |example|
          example["links"]["parent"][0]["document_type"] = nil
          example["withdrawn_notice"] = {
            'explanation': "This is out of date",
            'withdrawn_at': "2014-08-09T11:39:05Z",
          }
        end
      end

      it "shows withdrawn details with 'publication' as the type" do
        expect(page).to have_css(".gem-c-notice__title", text: "This publication was withdrawn on 9 August 2014")
      end
    end

    describe "does not render with the single page notification button" do
      let(:content_item) { GovukSchemas::Example.find(:html_publication, example_name: "published") }

      it "does not have the single page notification button" do
        expect(page).not_to have_css(".gem-c-single-page-notification-button")
      end
    end

    describe "a html publication that only applies to a set of nations, with alternative urls" do
      let(:content_item) { GovukSchemas::Example.find(:html_publication, example_name: "national_applicability_alternative_url_html_publication") }

      it "shows the devolved nations component" do
        within(".gem-c-devolved-nations") do
          expect(page).to have_text("Applies to England, Scotland and Wales")
          expect(page).to have_link("Publication for Northern Ireland", href: "http://www.dardni.gov.uk/news-dard-pa022-a-13-new-procedure-for")
        end
      end
    end

    describe "when the page has a parent that should be hidden from search engines" do
      let(:content_item) do
        GovukSchemas::Example.find(:html_publication, example_name: "published").tap do |example|
          example["links"]["parent"][0]["base_path"] = "/government/publications/govuk-app-testing-privacy-notice-how-we-use-your-data"
        end
      end

      it "adds a noindex meta tag" do
        expect(page).to have_css('meta[name="robots"][content="noindex"]', visible: :hidden)
      end
    end
  end
end
