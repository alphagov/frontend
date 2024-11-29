RSpec.describe "CallForEvidence" do
  it_behaves_like "it has meta tags", "call_for_evidence", "open_call_for_evidence", "/government/calls-for-evidence/youth-vaping-call-for-evidence"
  it_behaves_like "it has meta tags for images", "call_for_evidence", "open_call_for_evidence", "/government/calls-for-evidence/youth-vaping-call-for-evidence"

  context "when visiting an open call for evidence page" do
    before do
      @content_store_response = GovukSchemas::Example.find("call_for_evidence", example_name: "open_call_for_evidence")
      content_store_has_example_item("/government/calls-for-evidence/youth-vaping-call-for-evidence", schema: :call_for_evidence, example: :open_call_for_evidence)
      visit "/government/calls-for-evidence/youth-vaping-call-for-evidence"
    end

    it "displays the title" do
      expect(page).to have_title("Youth Vaping - GOV.UK")
      expect(page).to have_css("h1.gem-c-heading__text", text: @content_store_response["title"])
    end

    it "displays the call for evidence status" do
      within(".gem-c-heading__context") do
        expect(page).to have_content("Open call for evidence")
      end
    end

    it "displays the metadata" do
      within(".gem-c-metadata") do
        expect(page).to have_content("From: Office for Health Improvement and Disparities")
        expect(page).to have_content("Published 11 April 2023")
        expect(page).to have_content("Last updated 15 May 2023")
        expect(page).to have_link("See all updates", href: "#full-publication-update-history")
      end
    end

    it "includes ministers in metadata if present" do
      overrides = {
        "links" => {
          "people" => [
            {
              "base_path" => "/government/people/viscount-camrose",
              "title" => "Viscount Camrose",
            },
          ],
        },
      }

      @content_store_response.deep_merge!(overrides)
      stub_content_store_has_item("/government/calls-for-evidence/youth-vaping-call-for-evidence", @content_store_response)
      visit "/government/calls-for-evidence/youth-vaping-call-for-evidence"

      expect(page).to have_content("From: Office for Health Improvement and Disparities and Viscount Camrose")
    end

    it "displays the single page notification button at the top and bottom of page" do
      notification_button = page.find_all(".gem-c-single-page-notification-button")
      expect(notification_button.count).to eq(2)

      notification_button.each do
        expect(page).to have_css(".gem-c-single-page-notification-button", text: "Get emails about this page")
      end
    end

    it "displays the history notice if government information is available" do
      overrides = {
        "links" => {
          "government" => [
            "title" => "2015 Conservative government",
            "details" => {
              "current" => false,
            },
          ],
        },
      }

      @content_store_response.deep_merge!(overrides)
      stub_content_store_has_item("/government/calls-for-evidence/youth-vaping-call-for-evidence", @content_store_response)
      visit "/government/calls-for-evidence/youth-vaping-call-for-evidence"

      within(".gem-c-notice__title") do
        expect(page).to have_content("This was published under the #{@content_store_response.dig('details', 'government', 'title')}")
      end
    end

    it "does not display the history notice if government information is not available" do
      expect(page).not_to have_css(".gem-c-notice__title")
    end

    it "displays the national applicability banner if national information is available" do
      overrides = {
        "details" => {
          "national_applicability" => {
            "england" => {
              "label" => "England",
              "applicable" => true,
            },
          },
        },
      }

      @content_store_response.deep_merge!(overrides)
      stub_content_store_has_item("/government/calls-for-evidence/youth-vaping-call-for-evidence", @content_store_response)
      visit "/government/calls-for-evidence/youth-vaping-call-for-evidence"

      within(".gem-c-devolved-nations") do
        expect(page).to have_css("h2", text: "Applies to England")
      end
    end

    it "does not display the national applicability banner if national information is unavailable" do
      expect(page).not_to have_css(".gem-c-devolved-nations")
    end

    context "when it displays the blue summary box" do
      it "displays the heading" do
        within(".app-c-banner") do
          expect(page).to have_css("h2", text: "Summary")
        end
      end

      it "displays the description" do
        within(".app-c-banner") do
          expect(page).to have_css(".app-c-banner__desc", text: @content_store_response.dig("details", "description"))
        end
      end

      it "displays when the call for evidence closes" do
        within(".app-c-banner") do
          expect(page).to have_css(".app-c-banner__desc", text: "This call for evidence closes at 1:01pm on 16 April 2231")
        end
      end
    end

    it "displays the description" do
      within(".call-for-evidence-description") do
        expect(page).to have_css("h2", text: "Call for evidence description")

        expect(page).to have_content("The government is holding this call for evidence to identify opportunities to reduce the number of children (people aged under 18) accessing and using vape products, while ensuring they are still easily available as a quit aid for adult smokers.")
      end
    end

    it "links to external url call for evidence page" do
      expect(page).to have_link("another website", href: @content_store_response.dig("details", "held_on_another_website_url"))
    end

    context "when it displays the ways to respond" do
      before do
        content_store_response = GovukSchemas::Example.find("call_for_evidence", example_name: "open_call_for_evidence_with_participation")
        content_store_has_example_item("/government/calls-for-evidence/post-office-network", schema: :call_for_evidence, example: :open_call_for_evidence_with_participation)
        @ways_to_respond = content_store_response.dig("details", "ways_to_respond")
        visit "/government/calls-for-evidence/post-office-network"
      end

      it "displays the respond online link" do
        within(".call-for-evidence-ways-to-respond") do
          expect(page).to have_css(".call-to-action a[href='#{@ways_to_respond['link_url']}']", text: "Respond online")
        end
      end

      it "displays the email address" do
        within(".call-for-evidence-ways-to-respond") do
          expect(page).to have_css("a[href='mailto:#{@ways_to_respond['email']}']", text: @ways_to_respond["email"])
        end
      end

      it "displays the postal address formatted with line breaks" do
        within(".call-for-evidence-ways-to-respond") do
          expect(page).to have_css(".contact", text: "2016 Post Office Network Consultation Department for Business, Energy and Industrial Strategy 1 Victoria Street London SW1H 0ET")
          assert page.has_css?(".contact .content p", text: "2016 Post Office Network Consultation")
          assert page.has_css?(".contact .content p", text: "Department for Business, Energy and Industrial Strategy")
          assert page.has_css?(".contact .content p", text: "1 Victoria Street")
          assert page.has_css?(".contact .content p", text: "London")
          assert page.has_css?(".contact .content p", text: "SW1H 0ET")
        end
      end

      it "displays the response form" do
        within(".call-for-evidence-ways-to-respond") do
          expect(page).to have_css("a[href='#{@ways_to_respond['attachment_url']}']", text: "response form")
        end
      end
    end

    it "displays the share urls" do
      within(".gem-c-share-links") do
        expect(page).to have_css("h2", text: "Share this page")
        expect(page).to have_css("a", text: "Facebook")
        expect(page).to have_css("a", text: "Twitter")
      end
    end

    it "displays the published dates" do
      within(".app-c-published-dates--history") do
        expect(page).to have_content("Published 11 April 2023")
        expect(page).to have_content("Last updated 15 May 2023")
        expect(page).to have_content("7 November 2021")
        expect(page).to have_content("Added sub-topic tag.")
        expect(page).to have_link("show all updates", href: "#full-history")
      end
    end

    it "displays the print this page button" do
      within(".published-dates-button-group") do
        expect(page).to have_css(".gem-c-print-link__button", text: "Print this page")
      end
    end

    it "does not display outcome specific details" do
      expect(page).not_to have_css(".gem-c-notice")
      expect(page).not_to have_content("This call for evidence has closed")
      expect(page).not_to have_css("#read-the-full-outcome")
      expect(page).not_to have_content("Read the full outcome")
      expect(page).not_to have_css("h2", text: "Detail of outcome")
      expect(page).not_to have_css(".call-for-evidence-outcome-detail")
      expect(page).not_to have_css("h2", text: "Original call for evidence")
    end
  end

  context "when visiting a call for evidence outcome page" do
    before do
      @content_store_response = GovukSchemas::Example.find("call_for_evidence", example_name: "call_for_evidence_outcome_with_featured_attachments")
      content_store_has_example_item("/government/calls-for-evidence/setting-the-grade-standards-of-new-gcses-in-england-2017-2018", schema: :call_for_evidence, example: :call_for_evidence_outcome_with_featured_attachments)
      visit "/government/calls-for-evidence/setting-the-grade-standards-of-new-gcses-in-england-2017-2018"
    end

    it "displays the call for evidence status" do
      within(".gem-c-heading__context") do
        expect(page).to have_content("Call for evidence outcome")
      end
    end

    it "displays the status notice" do
      within(".gem-c-notice") do
        expect(page).to have_content("This call for evidence has closed")
      end
    end

    context "when displaying the 'read the full outcome' section" do
      it "shows the heading" do
        within("#read-the-full-outcome") do
          expect(page).to have_css("h2", text: "Read the full outcome")
        end
      end

      it "displays featured document attachments" do
        within("#read-the-full-outcome") do
          attachments = page.find_all(".gem-c-attachment")
          expect(attachments.length).to eq(2)
          expect(attachments[0]).to have_content("Decisions on setting the grade standards of new GCSEs in England - part 2")
          expect(attachments[1]).to have_content("Equalities impact assessment: setting the grade standards of new GCSEs in England")
        end
      end
    end

    it "displays the detail of outcome heading" do
      expect(page).to have_css("h2", text: "Detail of outcome")
    end

    it "displays the details of outcome description" do
      expect(page).to have_css(".call-for-evidence-outcome-detail")
    end

    it "displays the original call for evidence heading" do
      expect(page).to have_css("h2", text: "Original call for evidence")
    end

    context "when it displays the blue summary box" do
      it "displays the heading" do
        within(".app-c-banner") do
          expect(page).to have_css("h2", text: "Summary")
        end
      end

      it "displays the description" do
        within(".app-c-banner") do
          expect(page).to have_css(".app-c-banner__desc", text: @content_store_response["description"])
        end
      end

      it "displays the dates of when the call for evidence ran" do
        within(".app-c-banner") do
          expect(page).to have_css(".app-c-banner__desc", text: "This call for evidence ran frommidday on 22 April 2016 to 11:45pm on 17 June 2016")
        end
      end
    end

    it "displays the description" do
      within(".call-for-evidence-description") do
        expect(page).to have_css("h2", text: "Call for evidence description")

        expect(page).to have_content("We are seeking views on our proposals for setting grade standards for new GCSEs. This call for evidence follows on from our earlier call for evidence on ‘Setting the grade standards of new GCSEs in England")
      end
    end

    context "when attachments are available" do
      it "displays document attachments" do
        within("#documents") do
          expect(page).to have_css("h2", text: "Documents")
          expect(page).to have_css("h3", text: "Setting the grade standards of new GCSEs in England – part 2")
        end
      end

      it "displays accessible format option when accessible is false and email is supplied" do
        expected_attachment = @content_store_response.dig("details", "attachments", 0)
        attachments = page.find_all(".gem-c-attachment")
        expect(attachments[2]).to have_content(expected_attachment["title"])

        expect(attachments[2]).to have_content("Request an accessible format")
      end

      it "does not display accessible format option when accessible is true and email is supplied" do
        overrides = {
          "details" => {
            "attachments" => [
              {
                "accessible" => true,
                "alternative_format_contact_email" => "ddc-modinternet@mod.gov.uk",
                "attachment_type" => "file",
                "id" => "01",
                "title" => "Number of ex-regular service personnel now part of FR20",
                "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
                "content_type" => "application/pdf",
                "filename" => "PUBLIC_1392629965.pdf",
                "locale" => "en",
              },
            ],
            "featured_attachments" => %w[01],
          },
        }

        @content_store_response.deep_merge!(overrides)
        stub_content_store_has_item("/government/calls-for-evidence/setting-the-grade-standards-of-new-gcses-in-england-2017-2018", @content_store_response)
        visit "/government/calls-for-evidence/setting-the-grade-standards-of-new-gcses-in-england-2017-2018"

        attachments = page.find_all(".gem-c-attachment")
        expect(attachments[0]).not_to have_content("Request an accessible format")
      end

      it "does not display accessible format option when accessible is false and email is not supplied" do
        overrides = {
          "details" => {
            "attachments" => [
              {
                "accessible" => false,
                "attachment_type" => "file",
                "id" => "01",
                "title" => "Number of ex-regular service personnel now part of FR20",
                "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
                "content_type" => "application/pdf",
                "filename" => "PUBLIC_1392629965.pdf",
                "locale" => "en",
              },
            ],
            "featured_attachments" => %w[01],
          },
        }

        @content_store_response.deep_merge!(overrides)
        stub_content_store_has_item("/government/calls-for-evidence/setting-the-grade-standards-of-new-gcses-in-england-2017-2018", @content_store_response)
        visit "/government/calls-for-evidence/setting-the-grade-standards-of-new-gcses-in-england-2017-2018"

        attachments = page.find_all(".gem-c-attachment")
        expect(attachments[0]).not_to have_content("Request an accessible format")
      end

      it "tracks details elements in attachments correctly" do
        attachments = page.find_all(".gem-c-attachment")
        expect(attachments.length).to eq(3)

        attachments.each do |attachment|
          next unless attachment.has_css?(".govuk-details__summary")

          details = attachment.find("details")["data-ga4-event"]
          actual_tracking = JSON.parse(details)
          expect(actual_tracking["index_section_count"]).to eq(3)
        end
      end
    end

    it "does not display open specific details" do
      expect(page).not_to have_css(".call-for-evidence-ways-to-respond")
    end
  end

  context "when visiting an unopened call for evidence page" do
    before do
      content_store_has_example_item("/government/calls-for-evidence/setting-the-grade-standards-of-new-gcses-in-england-2017-2018", schema: :call_for_evidence, example: :unopened_call_for_evidence)
      visit "/government/calls-for-evidence/setting-the-grade-standards-of-new-gcses-in-england-2017-2018"
    end

    it "displays the call for evidence status" do
      within(".gem-c-heading__context") do
        expect(page).to have_content("Call for evidence")
      end
    end

    it "displays the status" do
      within(".gem-c-notice") do
        expect(page).to have_content("This call for evidence isn't open yet")
      end
    end

    context "when it displays the blue summary box" do
      it "displays the dates of when the call for evidence runs between" do
        within(".app-c-banner") do
          expect(page).to have_css(".app-c-banner__desc", text: "This call for evidence opens at 1pm on 5 October 2201")
          expect(page).to have_css(".app-c-banner__desc", text: "It closes at 4pm on 31 October 2211")
        end
      end
    end

    it "does not display open specific details" do
      expect(page).not_to have_css(".call-for-evidence-ways-to-respond")
    end

    it "does not display outcome specific details" do
      expect(page).not_to have_content("This call for evidence has closed")
      expect(page).not_to have_css("#read-the-full-outcome")
      expect(page).not_to have_content("Read the full outcome")
      expect(page).not_to have_css("h2", text: "Detail of outcome")
      expect(page).not_to have_css(".call-for-evidence-outcome-detail")
      expect(page).not_to have_css("h2", text: "Original call for evidence")
    end
  end

  context "when visiting a closed call for evidence pending outcome page" do
    before do
      content_store_has_example_item("/government/calls-for-evidence/setting-the-grade-standards-of-new-gcses-in-england-2017-2018", schema: :call_for_evidence, example: :closed_call_for_evidence)
      visit "/government/calls-for-evidence/setting-the-grade-standards-of-new-gcses-in-england-2017-2018"
    end

    it "displays the call for evidence status" do
      within(".gem-c-heading__context") do
        expect(page).to have_content("Closed call for evidence")
      end
    end

    context "when it displays the summary box" do
      it "displays the dates of when the call for evidence ran" do
        within(".app-c-banner") do
          expect(page).to have_css(".app-c-banner__desc", text: "This call for evidence ran from2pm on 29 September 2022 to 5pm on 27 October 2022")
        end
      end
    end

    it "does not display open specific details" do
      expect(page).not_to have_css(".call-for-evidence-ways-to-respond")
    end

    it "does not display outcome specific details" do
      expect(page).not_to have_content("This call for evidence has closed")
      expect(page).not_to have_css("#read-the-full-outcome")
      expect(page).not_to have_content("Read the full outcome")
      expect(page).not_to have_css("h2", text: "Detail of outcome")
      expect(page).not_to have_css(".call-for-evidence-outcome-detail")
      expect(page).not_to have_css("h2", text: "Original call for evidence")
    end
  end
end
