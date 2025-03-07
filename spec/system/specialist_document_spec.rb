RSpec.describe "Specialist Document" do
  describe "GET /<document_type>/<slug>" do
    let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "cma-cases-with-change-history") }
    let(:base_path) { content_store_response.fetch("base_path") }
    let(:finder_base_path) { content_store_response.dig("links", "finder", 0, "base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      stub_content_store_has_item(finder_base_path)
    end

    it_behaves_like "it has meta tags", "specialist_document", "cma-cases-with-change-history"

    it "displays the page" do
      visit base_path

      expect(page.status_code).to eq(200)
    end

    it "displays the title" do
      visit base_path

      expect(page).to have_title("#{content_store_response['title']} - GOV.UK")
      expect(page).to have_css("h1", text: content_store_response["title"])
    end

    it "displays breadcrumbs" do
      visit base_path

      expect(page).to have_css(".gem-c-contextual-breadcrumbs")
    end

    it "displays the description" do
      visit base_path

      expect(page).to have_text(content_store_response["description"].strip)
    end

    describe "facet metadata" do
      it "displays text facets" do
        content_store_response = GovukSchemas::Example.find("specialist_document", example_name: "aaib-reports")
        content_store_response["details"]["metadata"] = {
          "aircraft_type": "Rotorsport UK Calidus",
        }
        stub_content_store_has_item(base_path, content_store_response)

        visit base_path

        within(".important-metadata .gem-c-metadata") do
          expect(page).to have_css(".gem-c-metadata__term", text: "Aircraft type")
          expect(page).to have_css(".gem-c-metadata__definition", text: "Rotorsport UK Calidus")
        end
      end

      it "displays filterable text facets with a link to the finder" do
        content_store_response["details"]["metadata"] = {
          "case_type" => "mergers",
        }
        stub_content_store_has_item(base_path, content_store_response)

        visit base_path

        within(".important-metadata .gem-c-metadata") do
          expect(page).to have_css(".gem-c-metadata__term", text: "Case type")

          within(".gem-c-metadata__definition") do
            expect(page).to have_link("Mergers", href: "/cma-cases?case_type=mergers")
          end
        end
      end

      it "displays date facets" do
        content_store_response["details"]["metadata"] = {
          "opened_date": "2015-07-10",
        }
        stub_content_store_has_item(base_path, content_store_response)

        visit base_path

        within(".important-metadata .gem-c-metadata") do
          expect(page).to have_css(".gem-c-metadata__term", text: "Opened")
          expect(page).to have_css(".gem-c-metadata__definition", text: "10 July 2015")
        end
      end
    end

    it "displays contents list" do
      headers = content_store_response.dig("details", "headers")
      level_two_headers_count = headers.select { |header| header["level"] == 2 }.count
      level_three_headers_count = 0
      headers.each do |header|
        next if header["headers"].blank?

        header["headers"].each do |h|
          level_three_headers_count += 1 if h["level"] == 3
        end
      end

      visit base_path

      within ".gem-c-contents-list" do
        expect(all(".gem-c-contents-list__list-item--parent").size).to eq(level_two_headers_count)
        expect(all(".gem-c-contents-list__nested-list .gem-c-contents-list__list-item").size).to eq(level_three_headers_count)
      end
    end

    context "when there is more than one entry for change history" do
      it "displays full publisher metadata" do
        organisation = content_store_response.dig("links", "organisations", 0)

        visit base_path

        within ".metadata-column .gem-c-metadata" do
          expect(page).to have_link(organisation["title"], href: organisation["base_path"])
          expect(page).to have_text("Published 3 October 2024")
          expect(page).to have_text("Last updated 7 February 2025")
        end
      end

      it "displays change history" do
        visit base_path

        within(".app-c-published-dates__change-history") do
          expect(page.find(".app-c-published-dates__change-item:first-child").text)
            .to match(content_store_response["details"]["change_history"].last["note"])

          expect(page.find(".app-c-published-dates__change-item:last-child").text)
            .to match(content_store_response["details"]["change_history"].first["note"])

          expect(all(".app-c-published-dates__change-item").size)
            .to eq(content_store_response["details"]["change_history"].size)
        end
      end
    end

    context "when there is only one change history entry" do
      let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "protected-food-drink-names") }

      it "does not display last updated" do
        organisation = content_store_response.dig("links", "organisations", 0)

        visit base_path

        within ".metadata-column .gem-c-metadata" do
          expect(page).to have_link(organisation["title"], href: organisation["base_path"])
          expect(page).to have_text("Published 15 October 2020")
          expect(page).not_to have_text("Last updated 15 October 2020")
        end
      end

      it "does not display change history" do
        visit base_path

        expect(page).not_to have_css(".app-c-published-dates__change-history")
      end
    end

    it "displays protected designation logos" do
      content_store_response = GovukSchemas::Example.find("specialist_document", example_name: "protected-food-drink-names")
      stub_content_store_has_item(base_path, content_store_response)

      visit base_path

      expect(page).to have_css("img[src*='protected-designation-of-origin-pdo']")
    end

    it "displays a start button when continuation details exist" do
      content_store_response = GovukSchemas::Example.find("specialist_document", example_name: "business-finance-support-scheme")
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path

      expect(page).to have_css(".gem-c-button[href='http://www.bigissueinvest.com']", text: "Find out more")
      expect(page).to have_text("on the Big Issue Invest website")
    end

    it "does not render with the single page notification button" do
      visit base_path

      expect(page).not_to have_css(".gem-c-single-page-notification-button")
    end
  end
end
