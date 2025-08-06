RSpec.describe "Publication" do
  include SchemaOrgHelpers

  it_behaves_like "it has meta tags", "statistical_data_set", "statistical_data_set"

  context "when visiting a publication" do
    let(:content_item) { GovukSchemas::Example.find(:publication, example_name: "publication") }
    let(:base_path) { content_item["base_path"] }

    before { stub_content_store_has_item(base_path, content_item) }

    it "displays the title" do
      visit base_path

      expect(page).to have_title("D17 9LY, Veolia ES (UK) Limited: environmental permit issued")
    end

    it "includes the description" do
      visit base_path

      expect(page).to have_text("View the permit issued for Leeming Biogas Facility, Leeming under the Industrial Emissions Directive.")
    end

    it "includes the body" do
      visit base_path

      expect(page).to have_text("The Environment Agency publish permits that they issue under the Industrial Emissions Directive (IED).")
    end

    it "renders metadata" do
      visit base_path

      within("[class*='metadata-column']") do
        expect(page).to have_link("Environment Agency", href: "/government/organisations/environment-agency")
        expect(page).to have_link("The Rt Hon Sir Eric Pickles MP", href: "/government/people/eric-pickles")
        expect(page).to have_text("Published 3 May 2016")
      end
    end

    it "has structured data for an Article" do
      visit base_path

      expect(find_schema_of_type("Article")).not_to be_nil
    end

    it "shows the published date in the footer" do
      visit base_path

      expect(page).to have_selector(".gem-c-published-dates", text: "Published 3 May 2016")
    end

    context "when there are featured and non-featured attachments" do
      let(:content_item) do
        GovukSchemas::Example.find(:publication, example_name: "publication-with-featured-attachments").tap do |example|
          example["details"]["attachments"] << {
            "accessible" => false,
            "alternative_format_contact_email" => "customerservices@publicguardian.gov.uk",
            "attachment_type" => "file",
            "content_type" => "application/pdf",
            "filename" => "veolia-permit.pdf",
            "id" => "violia-permit",
            "locale" => "en",
            "title" => "Permit: Veolia ES (UK) Limited",
            "url" => "https://assets.publishing.service.gov.uk/media/123abc/veolia-permit.zip",
          }
        end
      end

      it "does not render non-featured attachments" do
        visit base_path

        expect(page).not_to have_text("Permit: Veolia ES (UK) Limited")
      end

      it "renders featured document attachments using components" do
        visit base_path

        within "#documents" do
          expect(page).to have_text("Number of ex-regular service personnel now part of FR20")
          expect(page).to have_selector(".gem-c-attachment")
        end
      end
    end

    context "when there are no featured attachments" do
      let(:content_item) do
        GovukSchemas::Example.find(:publication, example_name: "publication-with-featured-attachments").tap do |example|
          example["details"]["featured_attachments"] = []
        end
      end

      it "doesn't render the documents section" do
        visit base_path

        expect(page).not_to have_text("Documents")
      end
    end

    context "when the featured attachment is not accessible but an email is supplied" do
      let(:content_item) do
        GovukSchemas::Example.find(:publication, example_name: "publication-with-featured-attachments").tap do |example|
          example["details"]["attachments"].first["accessible"] = false
        end
      end

      it "renders the accessible format option" do
        visit base_path

        within "#documents" do
          expect(page).to have_text("Request an accessible format")
        end
      end

      it "adds GA4 tracking to the accessible format option" do
        visit base_path

        within "#documents" do
          attachments = page.find_all(".gem-c-attachment")

          expect(attachments.length).to eq(1)
          details = attachments.first.find("details")["data-ga4-event"]
          actual_tracking = JSON.parse(details)

          expect(actual_tracking["index_section_count"]).to eq(1)
        end
      end
    end

    context "when the featured attachment is not accessible and no email is supplied" do
      let(:content_item) do
        GovukSchemas::Example.find(:publication, example_name: "publication-with-featured-attachments").tap do |example|
          example["details"]["attachments"].first["accessible"] = false
          example["details"]["attachments"].first["alternative_format_contact_email"] = nil
        end
      end

      it "does not render the accessible format option" do
        visit base_path

        within "#documents" do
          expect(page).not_to have_text("Request an accessible format")
        end
      end
    end

    context "when the featured attachment is accessible and an email is supplied" do
      let(:content_item) { GovukSchemas::Example.find(:publication, example_name: "publication-with-featured-attachments") }

      it "does not render the accessible format option" do
        visit base_path

        within "#documents" do
          expect(page).not_to have_text("Request an accessible format")
        end
      end
    end

    context "when attachments are external links" do
      let(:content_item) do
        GovukSchemas::Example.find(:publication, example_name: "publication-with-featured-attachments").tap do |example|
          example["details"]["attachments"].first["url"] = "https://example.com"
          example["details"]["attachments"].first["attachment_type"] = "external"
        end
      end

      it "renders them as external links, not files" do
        visit base_path

        within "#documents" do
          expect(page).to have_link("Number of ex-regular service personnel now part of FR20", href: "https://example.com")
          expect(page).not_to have_text("PDF")
        end
      end
    end

    context "with a withdrawn publication" do
      let(:content_item) { GovukSchemas::Example.find(:publication, example_name: "withdrawn_publication") }

      it "displays the withdrawn title" do
        visit base_path

        expect(page).to have_selector("title", text: "[Withdrawn]", visible: :hidden)
      end

      it "displays the withdrawn notice" do
        visit base_path

        within ".gem-c-notice" do
          expect(page).to have_text("This publication was withdrawn")
          expect(page).to have_text("This information is now out of date.")
          expect(page).to have_selector("time[datetime='#{content_item['withdrawn_notice']['withdrawn_at']}']")
        end
      end
    end

    context "with a historically political publication" do
      let(:content_item) { GovukSchemas::Example.find(:publication, example_name: "political_publication") }

      it "shows the historical/political banner" do
        visit base_path

        within ".govuk-notification-banner__content" do
          expect(page).to have_text("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
        end
      end
    end

    context "when viewing a national statistics publication" do
      let(:content_item) { GovukSchemas::Example.find(:publication, example_name: "statistics_publication") }

      it "shows a logo" do
        visit base_path

        expect(page).to have_selector('img[alt="Accredited official statistics"]')
      end

      it "has structured data for a Dataset" do
        visit base_path

        expect(find_schema_of_type("Dataset")).not_to be_nil
      end
    end

    context "when visiting a publication that applies to a set of nations with alternative URLs" do
      let(:content_store_response) { GovukSchemas::Example.find("publication", example_name: "statistics_publication") }

      it "displays a devolved nations component with links to alternative URLs" do
        expect(page).to have_devolved_nations_component("Applies to England", [
          {
            text: "Publication for Northern Ireland",
            alternative_url: "http://www.dsdni.gov.uk/index/stats_and_research/stats-publications/stats-housing-publications/housing_stats.htm",
          },
          {
            text: "Publication for Scotland",
            alternative_url: "http://www.scotland.gov.uk/Topics/Statistics/Browse/Housing-Regeneration/HSfS",
          },
          {
            text: "Publication for Wales",
            alternative_url: "http://wales.gov.uk/topics/statistics/headlines/housing2012/121025/?lang=en",
          },
        ])
      end
    end
  end

  # test "renders with the single page notification button on English language pages" do
  #   setup_and_visit_content_item("publication")
  #   assert page.has_css?(".gem-c-single-page-notification-button")

  #   buttons = page.find_all(:button)

  #   expected_tracking_top = single_page_notification_button_ga4_tracking(1, "Top")
  #   actual_tracking_top = JSON.parse(buttons.first["data-ga4-link"])
  #   assert_equal expected_tracking_top, actual_tracking_top

  #   expected_tracking_bottom = single_page_notification_button_ga4_tracking(2, "Footer")
  #   actual_tracking_bottom = JSON.parse(buttons.last["data-ga4-link"])
  #   assert_equal expected_tracking_bottom, actual_tracking_bottom
  # end

  # test "does not render the single page notification button on exempt pages" do
  #   setup_and_visit_notification_exempt_page("publication")
  #   assert_not page.has_css?(".gem-c-single-page-notification-button")
  # end

  # test "does not render the single page notification button on foreign language pages" do
  #   setup_and_visit_content_item("publication", "locale" => "cy")
  #   assert_not page.has_css?(".gem-c-single-page-notification-button")
  # end

  # test "adds the noindex meta tag to '/government/publications/pension-credit-claim-form--2'" do
  #   overrides = { "base_path" => "/government/publications/pension-credit-claim-form--2" }
  #   setup_and_visit_content_item("publication-with-featured-attachments", overrides)
  #   assert page.has_css?('meta[name="robots"][content="noindex"]', visible: false)
  # end

  # test "adds the noindex meta tag to mobile paths" do
  #   mobile_paths = %w[
  #     /government/publications/govuk-app-terms-and-conditions
  #     /government/publications/govuk-app-privacy-notice-how-we-use-your-data
  #     /government/publications/govuk-app-testing-privacy-notice-how-we-use-your-data
  #     /government/publications/accessibility-statement-for-the-govuk-app
  #   ]
  #   mobile_paths.each do |path|
  #     overrides = { "base_path" => path }
  #     setup_and_visit_content_item("publication-with-featured-attachments", overrides)
  #     assert page.has_css?('meta[name="robots"][content="noindex"]', visible: false)
  #   end
  # end

  # test "translates Welsh published date correctly" do
  #   setup_and_visit_content_item("publication", { "locale" => "cy" })

  #   assert_has_metadata({
  #     published: "3 Mai 2016",
  #     from: {
  #       "Environment Agency": "/government/organisations/environment-agency",
  #       "The Rt Hon Sir Eric Pickles MP": "/government/people/eric-pickles",
  #     },
  #   })

  #   assert_footer_has_published_dates("Cyhoeddwyd ar 3 Mai 2016")
  # end
end
