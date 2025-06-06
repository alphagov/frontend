RSpec.describe "CalForEvidence" do
  # def setup
  #   super
  #   Timecop.freeze(Time.zone.local(2023))
  # end

  # def teardown
  #   super
  #   Timecop.return
  # end

  # general_overrides = {
  #   "details" => {
  #     "attachments" => [
  #       {
  #         "accessible" => false,
  #         "alternative_format_contact_email" => "publications@ofqual.gov.uk",
  #         "attachment_type" => "file",
  #         "command_paper_number" => "",
  #         "content_type" => "application/pdf",
  #         "file_size" => 803,
  #         "filename" => "Setting_grade_standards_part_2.pdf",
  #         "hoc_paper_number" => "",
  #         "id" => "01",
  #         "isbn" => "",
  #         "number_of_pages" => 33,
  #         "title" => "Setting the grade standards of new GCSEs in England – part 2",
  #         "unique_reference" => "Ofqual/16/5939",
  #         "unnumbered_command_paper" => false,
  #         "unnumbered_hoc_paper" => false,
  #         "url" => "https://assets.publishing.service.gov.uk/media/5a7f7b63ed915d74e33f6b3d/Setting_grade_standards_part_2.pdf",
  #       },
  #       {
  #         "accessible" => false,
  #         "alternative_format_contact_email" => "publications@ofqual.gov.uk",
  #         "attachment_type" => "file",
  #         "command_paper_number" => "",
  #         "content_type" => "application/pdf",
  #         "file_size" => 365,
  #         "filename" => "Decisions_-_setting_GCSE_grade_standards_-_part_2.pdf",
  #         "hoc_paper_number" => "",
  #         "id" => "02",
  #         "isbn" => "",
  #         "number_of_pages" => 10,
  #         "title" => "Decisions on setting the grade standards of new GCSEs in England - part 2",
  #         "unique_reference" => "Ofqual/16/6102",
  #         "unnumbered_command_paper" => false,
  #         "unnumbered_hoc_paper" => false,
  #         "url" => "https://assets.publishing.service.gov.uk/media/5a817d87ed915d74e62328cf/Decisions_-_setting_GCSE_grade_standards_-_part_2.pdf",
  #       },
  #       {
  #         "accessible" => false,
  #         "alternative_format_contact_email" => "publications@ofqual.gov.uk",
  #         "attachment_type" => "file",
  #         "command_paper_number" => "",
  #         "content_type" => "application/pdf",
  #         "file_size" => 646,
  #         "filename" => "Grading-consulation-Equalities-Impact-Assessment.pdf",
  #         "hoc_paper_number" => "",
  #         "id" => "03",
  #         "isbn" => "",
  #         "number_of_pages" => 5,
  #         "title" => "Equalities impact assessment: setting the grade standards of new GCSEs in England – part 2",
  #         "unique_reference" => "Ofqual/16/6104",
  #         "unnumbered_command_paper" => false,
  #         "unnumbered_hoc_paper" => false,
  #         "url" => "https://assets.publishing.service.gov.uk/media/5a8014d6ed915d74e622c5af/Grading-consulation-Equalities-Impact-Assessment.pdf",
  #       },
  #       {
  #         "accessible" => false,
  #         "alternative_format_contact_email" => "publications@ofqual.gov.uk",
  #         "attachment_type" => "file",
  #         "content_type" => "application/pdf",
  #         "file_size" => 175,
  #         "filename" => "Grading-consultation-analysis-of-responses.pdf",
  #         "id" => "04",
  #         "number_of_pages" => 24,
  #         "title" => "Analysis of responses to our consultation on setting the grade standards of new GCSEs in England – part 2",
  #         "url" => "https://assets.publishing.service.gov.uk/media/5a819d85ed915d74e6233377/Grading-consultation-analysis-of-responses.pdf",
  #       },
  #     ],
  #     "outcome_attachments" => %w[01],
  #     "featured_attachments" => %w[02],
  #   },
  # }

  context "when visiting a call for evidence page" do
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
        expect(page).to have_content("From: Office for Health Improvement and Disparities and The Rt Hon Baroness Smith of Malvern")
        expect(page).to have_content("Published 11 April 2023")
        expect(page).to have_content("Last updated 15 May 2023")
        expect(page).to have_link("See all updates", href: "#full-publication-update-history")
      end
    end

    context "when it displays the single page notification button" do
      it "displays the button at the top and bottom of page on English languag pages" do
        notification_button = page.find_all(".gem-c-single-page-notification-button")
        expect(notification_button.count).to eq(2)

        notification_button.each do
          expect(page).to have_css(".gem-c-single-page-notification-button", text: "Get emails about this page")
        end
      end

      it "does not display the button on foreign language pages" do
        @content_store_response["locale"] = "cy"
        stub_content_store_has_item("/government/calls-for-evidence/youth-vaping-call-for-evidence", @content_store_response)
        visit "/government/calls-for-evidence/youth-vaping-call-for-evidence"

        expect(page).not_to have_css(".gem-c-single-page-notification-button")
      end

      it "does not render the button on exempt pages" do
        @content_store_response["content_id"] = "c5c8d3cd-0dc2-4ca3-8672-8ca0a6e92165"
        stub_content_store_has_item("/government/calls-for-evidence/youth-vaping-call-for-evidence", @content_store_response)
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
        within(".gem-c-summary-banner") do
          expect(page).to have_css("h2", text: "Summary")
        end
      end

      it "displays the description" do
        within(".gem-c-summary-banner") do
          expect(page).to have_css(".gem-c-summary-banner__text", text: @content_store_response.dig("details", "description"))
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
      let(:overrides) do
        {
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
      end

      it "displays the document heading" do
        @content_store_response.deep_merge!(overrides)
        stub_content_store_has_item("/government/calls-for-evidence/youth-vaping-call-for-evidence", @content_store_response)
        visit "/government/calls-for-evidence/youth-vaping-call-for-evidence"

        within("#documents") do
          expect(page).to have_css("h2", text: "Documents")
        end
      end

      it "displays document attachments" do
        @content_store_response.deep_merge!(overrides)
        stub_content_store_has_item("/government/calls-for-evidence/youth-vaping-call-for-evidence", @content_store_response)
        visit "/government/calls-for-evidence/youth-vaping-call-for-evidence"

        within("#documents") do
          expect(page).to have_css("h3", text: "Number of ex-regular service personnel now part of FR20")
        end
      end

      it "displays accessible format option when accessible is false and email is supplied" do
        overrides["details"]["attachments"].first["accessible"] = false
        @content_store_response.deep_merge!(overrides)
        stub_content_store_has_item("/government/calls-for-evidence/youth-vaping-call-for-evidence", @content_store_response)
        visit "/government/calls-for-evidence/youth-vaping-call-for-evidence"

        expected_attachment = @content_store_response.dig("details", "attachments", 0)
        attachments = page.find_all(".gem-c-attachment")

        expect(attachments[0]).to have_content(expected_attachment["title"])
        expect(attachments[0]).to have_content("Request an accessible format")
      end

      it "does not display accessible format option when accessible is true and email is supplied" do
        @content_store_response.deep_merge!(overrides)
        stub_content_store_has_item("/government/calls-for-evidence/setting-the-grade-standards-of-new-gcses-in-england-2017-2018", @content_store_response)
        visit "/government/calls-for-evidence/setting-the-grade-standards-of-new-gcses-in-england-2017-2018"

        attachments = page.find_all(".gem-c-attachment")
        expect(attachments[0]).not_to have_content("Request an accessible format")
      end

      it "does not display accessible format option when accessible is false and email is not supplied" do
        overrides["details"]["attachments"].first["accessible"] = false
        overrides["details"]["attachments"].first.delete("alternative_format_contact_email")

        @content_store_response.deep_merge!(overrides)
        stub_content_store_has_item("/government/calls-for-evidence/youth-vaping-call-for-evidence", @content_store_response)
        visit "/government/calls-for-evidence/youth-vaping-call-for-evidence"

        attachments = page.find_all(".gem-c-attachment")
        expect(attachments[0]).not_to have_content("Request an accessible format")
      end

      it "tracks details elements in attachments correctly" do
        @content_store_response.deep_merge!(overrides)
        stub_content_store_has_item("/government/calls-for-evidence/youth-vaping-call-for-evidence", @content_store_response)
        visit "/government/calls-for-evidence/youth-vaping-call-for-evidence"

        attachments = page.find_all(".gem-c-attachment")
        expect(attachments.length).to eq(1)

        attachments.each do |attachment|
          next unless attachment.has_css?(".govuk-details__summary")

          details = attachment.find("details")["data-ga4-event"]
          actual_tracking = JSON.parse(details)
          expect(actual_tracking["index_section_count"]).to eq(1)
        end
      end
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
