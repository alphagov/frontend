RSpec.describe "Guide" do
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

      context "when in a step by step guide" do
        let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide-with-step-navs-and-hide-navigation") }

        it "replaces the guide title with the part title" do
          expect(page).not_to have_css("h1", text: content_store_response["title"])
          expect(page).to have_css("h1", text: content_store_response["details"]["parts"][0]["title"])
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
  end

  # test "draft access tokens are appended to part links within navigation" do
  #   setup_and_visit_content_item_with_params("guide", "?token=some_token")

  #   assert page.has_css?('.gem-c-contents-list a[href$="?token=some_token"]')
  # end

  # test "does not show guide navigation and print link if in a step by step and hide_chapter_navigation is true" do
  #   setup_and_visit_content_item("guide-with-step-navs-and-hide-navigation")

  #   assert_not page.has_css?(".govuk-pagination")
  #   assert_not page.has_css?(".govuk-link.govuk-link--no-visited-state[href$='/print']")
  # end

  # test "shows guide navigation and print link if not in a step by step and hide_chapter_navigation is true" do
  #   setup_and_visit_content_item("guide-with-hide-navigation")

  #   assert page.has_css?(".govuk-pagination")
  #   assert page.has_css?(".govuk-link.govuk-link--no-visited-state[href$='/print']", text: "View a printable version of the whole guide")
  # end

  # test "guides with no parts in a step by step with hide_chapter_navigation do not error" do
  #   setup_and_visit_content_item("no-part-guide-with-step-navs-and-hide-navigation")
  #   title = @content_item["title"]

  #   assert_has_component_title(title)
  # end

  # test "guides show the faq page schema" do
  #   setup_and_visit_content_item("guide")
  #   faq_schema = find_structured_data(page, "FAQPage")

  #   assert_equal faq_schema["@type"], "FAQPage"
  #   assert_equal faq_schema["headline"], "The national curriculum"

  #   q_and_as = faq_schema["mainEntity"]
  #   answers = q_and_as.map { |q_and_a| q_and_a["acceptedAnswer"] }

  #   chapter_titles = [
  #     "Overview",
  #     "Key stage 1 and 2",
  #     "Key stage 3 and 4",
  #     "Other compulsory subjects",
  #   ]
  #   assert_equal(chapter_titles, q_and_as.map { |q_and_a| q_and_a["name"] })

  #   guide_part_urls = [
  #     "https://www.test.gov.uk/national-curriculum",
  #     "https://www.test.gov.uk/national-curriculum/key-stage-1-and-2",
  #     "https://www.test.gov.uk/national-curriculum/key-stage-3-and-4",
  #     "https://www.test.gov.uk/national-curriculum/other-compulsory-subjects",
  #   ]
  #   assert_equal(guide_part_urls, q_and_as.map { |q_and_a| q_and_a["url"] })
  #   assert_equal(guide_part_urls, answers.map { |answer| answer["url"] })
  # end

  # test "guide chapters do not show the faq schema" do
  #   setup_and_visit_part_in_guide
  #   faq_schema = find_structured_data(page, "FAQPage")

  #   assert_nil faq_schema
  # end

  # test "does not render with the single page notification button" do
  #   setup_and_visit_content_item("guide")
  #   assert_not page.has_css?(".gem-c-single-page-notification-button")
  # end

  # test "print link has GA4 tracking" do
  #   setup_and_visit_content_item("guide")

  #   expected_ga4_json = {
  #     event_name: "navigation",
  #     type: "print page",
  #     section: "Footer",
  #     text: "View a printable version of the whole guide",
  #   }.to_json

  #   assert page.has_css?("a[data-ga4-link='#{expected_ga4_json}']")
  # end
end
