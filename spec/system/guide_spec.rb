RSpec.describe "Guide" do
  include SchemaOrgHelpers

  context "when visiting a guide" do
    let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "displays the guide title" do
      expect(page).to have_title("The national curriculum: Overview - GOV.UK")
      expect(page).to have_css("h1.gem-c-heading__text", text: content_store_response["title"])
    end

    it "displays the part title" do
      expect(page).to have_css("h1.gem-c-heading__text", text: "Overview")
    end

    it "displays the navigation" do
      parts_size = content_store_response["details"]["parts"].size

      expect(page).to have_css(".part-navigation-container nav li", count: parts_size)
      expect(page).to have_css(".part-navigation-container nav li", text: content_store_response["details"]["parts"].first["title"])
      expect(page).not_to have_css(".part-navigation li a", text: content_store_response["details"]["parts"].first["title"])

      content_store_response["details"]["parts"][1..parts_size].each do |part|
        expect(page).to have_css(".part-navigation-container nav li a[href*=\"#{part['slug']}\"]", text: part["title"])
      end

      expect(page).to have_css(".govuk-pagination")
      expect(page).to have_css('.govuk-link.govuk-link--no-visited-state[href$="/print"]', text: I18n.t("multi_page.print_entire_guide"))
    end

    it "shows the skip link" do
      expect(page).to have_css(".gem-c-skip-link", text: "Skip contents")
    end

    context "when the guide is in Welsh" do
      let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide").tap { |csr| csr.merge!("locale" => "cy") } }

      it "shows the skip link in Welsh" do
        expect(page).to have_css(".gem-c-skip-link", text: "Sgipio cynnwys")
      end
    end

    context "when visiting a single-page guide" do
      let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "single-page-guide") }

      it "doesn't show part navigation, print link, or part title" do
        expect(page).not_to have_css("h1", text: content_store_response["details"]["parts"].first["title"])
        expect(page).not_to have_css(".gem-c-print-link")
      end
    end

    context "when hide_chapter_navigation is true in the content item" do
      let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide-with-hide-navigation") }

      it "shows the guide title and the part title" do
        expect(page).to have_css("h1", text: content_store_response["title"])
        expect(page).to have_css("h1", text: content_store_response["details"]["parts"][0]["title"])
      end

      it "does not show guide navigation or print link" do
        expect(page).to have_css(".govuk-pagination")
        expect(page).to have_css(".govuk-link.govuk-link--no-visited-state[href$='/print']")
      end

      context "when in a step by step guide" do
        let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide-with-step-navs-and-hide-navigation") }

        it "replaces the guide title with the part title" do
          expect(page).not_to have_css("h1", text: content_store_response["title"])
          expect(page).to have_css("h1", text: content_store_response["details"]["parts"][0]["title"])
        end

        it "does not show guide navigation or print link" do
          expect(page).not_to have_css(".govuk-pagination")
          expect(page).not_to have_css(".govuk-link.govuk-link--no-visited-state[href$='/print']")
        end

        context "when in a single-page guide" do
          let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "single-page-guide-with-step-navs-and-hide-navigation") }

          it "replaces the guide title with the part title" do
            expect(page).not_to have_css("h1", text: content_store_response["title"])
            expect(page).to have_css("h1", text: content_store_response["details"]["parts"][0]["title"])
          end
        end
      end
    end

    it "includes the faq page schema" do
      expect(find_schema_of_type("FAQPage")).not_to be_nil
    end

    context "when visiting part of a guide" do
      before do
        visit "#{base_path}/key-stage-1-and-2"
      end

      it "does not include the faq page schema" do
        expect(find_schema_of_type("FAQPage")).to be_nil
      end
    end

    it "has GA4 tracking on the print link" do
      expected_ga4_json = {
        event_name: "navigation",
        type: "print page",
        section: "Footer",
        text: "View a printable version of the whole guide",
      }.to_json

      expect(page).to have_css("a[data-ga4-link='#{expected_ga4_json}']")
    end
  end

  # test "draft access tokens are appended to part links within navigation" do
  #   setup_and_visit_content_item_with_params("guide", "?token=some_token")

  #   assert page.has_css?('.gem-c-contents-list a[href$="?token=some_token"]')
  # end
end
