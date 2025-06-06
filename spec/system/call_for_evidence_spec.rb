RSpec.describe "CallForEvidence" do
  context "when visiting a call for evidence page" do
    let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "open_call_for_evidence") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "displays the title" do
      expect(page).to have_title("Youth Vaping - GOV.UK")
      expect(page).to have_css("h1.gem-c-heading__text", text: content_store_response["title"])
    end

    it "displays the metadata" do
      within(".gem-c-metadata") do
        expect(page).to have_content("From: Office for Health Improvement and Disparities and The Rt Hon Baroness Smith of Malvern")
        expect(page).to have_content("Published 11 April 2023")
        expect(page).to have_content("Last updated 15 May 2023")
        expect(page).to have_link("See all updates", href: "#full-publication-update-history")
      end
    end

    context "when it displays the single page notification button" do
      it "displays the button at the top and bottom of page on English language pages" do
        notification_button = page.find_all(".gem-c-single-page-notification-button")
        expect(notification_button.count).to eq(2)

        notification_button.each do
          expect(page).to have_css(".gem-c-single-page-notification-button", text: "Get emails about this page")
        end
      end

      it "does not display the button on foreign language pages" do
        content_store_response["locale"] = "cy"
        stub_content_store_has_item("/government/calls-for-evidence/youth-vaping-call-for-evidence", content_store_response)
        visit "/government/calls-for-evidence/youth-vaping-call-for-evidence"

        expect(page).not_to have_css(".gem-c-single-page-notification-button")
      end

      it "does not render the button on exempt pages" do
        content_store_response["content_id"] = "c5c8d3cd-0dc2-4ca3-8672-8ca0a6e92165"
        stub_content_store_has_item("/government/calls-for-evidence/youth-vaping-call-for-evidence", content_store_response)
        visit "/government/calls-for-evidence/youth-vaping-call-for-evidence"

        expect(page).not_to have_css(".gem-c-single-page-notification-button")
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

      content_store_response.deep_merge!(overrides)
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path

      within(".gem-c-notice__title") do
        expect(page).to have_content("This was published under the #{content_store_response.dig('details', 'government', 'title')}")
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

      content_store_response.deep_merge!(overrides)
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path

      within(".gem-c-devolved-nations") do
        expect(page).to have_css("h2", text: "Applies to England")
      end
    end

    it "does not display the national applicability banner if national information is unavailable" do
      expect(page).not_to have_css(".gem-c-devolved-nations")
    end

    context "when it displays the blue summary box" do
      it "displays the heading" do
        within(".gem-c-summary-banner") do
          expect(page).to have_css("h2", text: "Summary")
        end
      end

      it "displays the description" do
        within(".gem-c-summary-banner") do
          expect(page).to have_css(".gem-c-summary-banner__text", text: content_store_response.dig("details", "description"))
        end
      end
    end

    it "displays the document description" do
      within(".call-for-evidence-description") do
        expect(page).to have_css("h2", text: "Call for evidence description")
        expect(page).to have_content("The government is holding this call for evidence to identify opportunities to reduce the number of children (people aged under 18) accessing and using vape products, while ensuring they are still easily available as a quit aid for adult smokers.")
      end
    end

    context "when attachments are available" do
      let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "call_for_evidence_outcome_with_featured_attachments") }
      let(:base_path) { content_store_response.fetch("base_path") }

      before do
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
      end

      it "displays the document heading" do
        within("#documents") do
          expect(page).to have_css("h2", text: "Documents")
        end
      end

      it "displays document attachments" do
        within("#documents") do
          expect(page).to have_css("h3", text: "Setting the grade standards of new GCSEs in England – part 2")
        end
      end

      it "displays accessible format option when accessible is false and email is supplied" do
        within("#documents") do
          attachments = page.find_all(".gem-c-attachment")

          expect(attachments[0]).to have_content("Request an accessible format")
        end
      end

      it "does not display accessible format option when accessible is true and email is supplied" do
        content_store_response["details"]["attachments"][0]["accessible"] = true
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path

        within("#documents") do
          attachments = page.find_all(".gem-c-attachment")
          expect(attachments[0]).not_to have_content("Request an accessible format")
        end
      end

      it "does not display accessible format option when accessible is false and email is not supplied" do
        content_store_response["details"]["attachments"][0].delete("alternative_format_contact_email")
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path

        within("#documents") do
          attachments = page.find_all(".gem-c-attachment")
          expect(attachments[0]).not_to have_content("Request an accessible format")
        end
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

    context "when it displays the ways to respond" do
      let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "open_call_for_evidence_with_participation") }
      let(:base_path) { content_store_response.fetch("base_path") }
      let(:ways_to_respond) { content_store_response.dig("details", "ways_to_respond") }

      before do
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
      end

      it "displays the respond online link" do
        within(".call-for-evidence-ways-to-respond") do
          expect(page).to have_css(".call-to-action a[href='#{ways_to_respond['link_url']}']", text: "Respond online")
        end
      end

      it "displays the email address" do
        within(".call-for-evidence-ways-to-respond") do
          expect(page).to have_css("a[href='mailto:#{ways_to_respond['email']}']", text: ways_to_respond["email"])
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
          expect(page).to have_css("a[href='#{ways_to_respond['attachment_url']}']", text: "response form")
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

    it "displays the published dates history in the footer" do
      within(".gem-c-published-dates--history") do
        expect(page).to have_content("Published 11 April 2023")
        expect(page).to have_content("Last updated 15 May 2023")
        expect(page).to have_content("7 November 2021")
        expect(page).to have_content("Added sub-topic tag.")
        expect(page).to have_link("show all updates", href: "#full-history")
      end
    end
  end

  # test "renders featured document attachments" do
  #   setup_and_visit_content_item("call_for_evidence_outcome_with_featured_attachments")

  #   assert page.has_text?("Documents")
  #   within "#documents" do
  #     assert page.has_text?("Setting the grade standards of new GCSEs in England – part 2")
  #   end
  # end

  # test "unopened call for evidence" do
  #   setup_and_visit_content_item("unopened_call_for_evidence", {
  #     "details" => {
  #       "closing_date" => "2023-02-01T13:00:00.000+00:00",
  #       "opening_date" => "2023-01-02T13:00:00.000+00:00",
  #     },
  #   })

  #   assert page.has_text?("Call for evidence")

  #   assert page.has_css?(".gem-c-notice", text: "This call for evidence opens at 1pm on 2 January 2023")
  #   assert page.has_text?(:all, "It closes at 1pm on 1 February 2023")
  # end

  # test "closed call for evidence pending outcome" do
  #   setup_and_visit_content_item("closed_call_for_evidence")

  #   assert page.has_text?("Closed call for evidence")

  #   assert page.has_text?("ran from")
  #   assert page.has_text?("2pm on 29 September 2022 to 5pm on 27 October 2022")
  # end

  # test "call for evidence outcome" do
  #   setup_and_visit_content_item("call_for_evidence_outcome", {
  #     "details" => {
  #       "closing_date" => "2022-02-01T13:00:00.000+00:00",
  #       "opening_date" => "2022-01-01T13:00:00.000+00:00",
  #     },
  #   })
  #   assert page.has_text?("Call for evidence outcome")
  #   assert page.has_css?(".gem-c-notice", text: "This call for evidence has closed")
  #   assert page.has_css?("h2", text: "Original call for evidence")
  #   assert page.has_text?("ran from")
  #   assert page.has_text?("1pm on 1 January 2022 to 1pm on 1 February 2022")

  #   within ".call-for-evidence-outcome-detail" do
  #     assert page.has_text?(@content_item["details"]["outcome_detail"])
  #   end
  # end

  # test "renders call for evidence outcome attachments" do
  #   setup_and_visit_content_item("call_for_evidence_outcome", general_overrides)

  #   assert page.has_text?("This call for evidence has closed")
  #   assert page.has_text?("Read the full outcome")
  #   within "#read-the-full-outcome" do
  #     assert page.has_text?("Setting the grade standards of new GCSEs in England – part 2")
  #   end
  # end

  # test "renders featured call for evidence outcome attachments" do
  #   setup_and_visit_content_item("call_for_evidence_outcome_with_featured_attachments")

  #   assert page.has_text?("Read the full outcome")
  #   within "#read-the-full-outcome" do
  #     assert page.has_text?("Equalities impact assessment: setting the grade standards of new GCSEs in England – part 2")
  #   end
  # end
end
