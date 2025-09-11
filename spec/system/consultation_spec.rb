RSpec.describe "Consultation" do
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
  #     "final_outcome_attachments" => %w[01],
  #     "public_feedback_attachments" => %w[02],
  #     "featured_attachments" => %w[03],
  #   },
  # }

  context "when visiting a consultation page" do
    let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "open_consultation") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "displays the title" do
      expect(page).to have_title("Postgraduate doctoral loans - GOV.UK")
      expect(page).to have_css("h1.gem-c-heading__text", text: content_store_response["title"])
    end

    it "displays the metadata" do
      within(".gem-c-metadata") do
        expect(page).to have_content("From: Department for Education")
        expect(page).to have_content("Published 4 November 2016")
        expect(page).to have_content("Last updated 7 November 2016")
        expect(page).to have_link("See all updates", href: "#full-publication-update-history")
      end
    end

    it "displays the published dates history in the footer" do
      within(".gem-c-published-dates--history") do
        expect(page).to have_content("Published 4 November 2016")
        expect(page).to have_content("Last updated 7 November 2016")
        expect(page).to have_content("7 November 2011")
        expect(page).to have_content("Added sub-topic tag.")
        expect(page).to have_link("show all updates", href: "#full-history")
      end
    end

    it "displays the document description" do
      within(".consultation-description") do
        expect(page).to have_css("h2", text: "Consultation description")
        expect(page).to have_content("We are seeking external views on a postgraduate doctoral loan.")
      end
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

    context "when document attachments are available" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "consultation_outcome_with_featured_attachments") }
      let(:base_path) { content_store_response.fetch("base_path") }

      before do
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
      end

      it "renders the document heading" do
        within("#documents") do
          expect(page).to have_css("h2", text: "Documents")
        end
      end

      it "renders document attachments" do
        within("#documents") do
          expect(page).to have_css("h3", text: "Setting the grade standards of new GCSEs in England – part 2")
        end
      end

      it "renders accessible format option when accessible is false and email is supplied" do
        within("#documents") do
          attachments = page.find_all(".gem-c-attachment")

          expect(attachments[0]).to have_content("Request an accessible format")
        end
      end

      it "doesn't render accessible format option when accessible is true and email is supplied" do
        content_store_response["details"]["attachments"][0]["accessible"] = true

        stub_content_store_has_item(base_path, content_store_response)
        visit base_path

        within "#documents" do
          attachments = page.find_all(".gem-c-attachment")

          expect(attachments[0]).not_to have_content("Request an accessible format")
        end
      end

      it "doesn't render accessible format option when accessible is false and email is not supplied" do
        content_store_response["details"]["attachments"][0].delete("alternative_format_contact_email")

        stub_content_store_has_item(base_path, content_store_response)
        visit base_path

        within "#documents" do
          attachments = page.find_all(".gem-c-attachment")

          expect(attachments[0]).not_to have_content("Request an accessible format")
        end
      end

      it "tracks details elements in attachments correctly" do
        attachments = page.find_all(".gem-c-attachment")

        expect(attachments.length).to eq(4)

        attachments.each do |attachment|
          next unless attachment.has_css?(".govuk-details__summary")

          details = attachment.find("details")["data-ga4-event"]
          actual_tracking = JSON.parse(details)
          expect(actual_tracking["index_section_count"]).to eq(4)
        end
      end
    end

    context "when it renders the ways to respond" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "open_consultation_with_participation") }
      let(:base_path) { content_store_response.fetch("base_path") }
      let(:ways_to_respond) { content_store_response.dig("details", "ways_to_respond") }

      before do
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
      end

      it "displays the respond online link" do
        within(".consultation-ways-to-respond") do
          expect(page).to have_css(".call-to-action a[href='#{ways_to_respond['link_url']}']", text: "Respond online")
        end
      end

      it "displays the email address" do
        within(".consultation-ways-to-respond") do
          expect(page).to have_css("a[href='mailto:po.consultation@ukgi.gov.uk']", text: "po.consultation@ukgi.gov.uk")
        end
      end

      it "displays the postal address formatted with line breaks" do
        within(".consultation-ways-to-respond") do
          assert page.has_css?(".contact .content p", text: "2016 Post Office Network Consultation")
        end
      end

      it "displays the response form" do
        within(".consultation-ways-to-respond") do
          expect(page).to have_css("a[href='https://www.gov.uk/government/uploads/system/uploads/consultation_response_form_data/file/533/beis-16-36rf-post-office-network-consultation-response-form.docx']", text: "response form")
        end
      end
    end
  end

  # test "link to external consultations" do
  #   setup_and_visit_content_item("open_consultation")

  #   assert page.has_css?("a[href=\"#{@content_item['details']['held_on_another_website_url']}\"]", text: "another website")
  # end

  # test "open consultation" do
  #   setup_and_visit_content_item("open_consultation")

  #   assert page.has_text?("Open consultation")
  #   assert page.has_text?(:all, "closes at 3pm on 16 December 2216")
  # end

  # test "unopened consultation" do
  #   setup_and_visit_content_item("unopened_consultation")

  #   assert page.has_text?("Consultation")

  #   # There's no daylight savings after 2037
  #   # http://timezonesjl.readthedocs.io/en/stable/faq/#far-future-zoneddatetime-with-variabletimezone
  #   assert page.has_css?(".gem-c-notice", text: "This consultation opens at 1pm on 5 October 2200")
  #   assert page.has_text?(:all, "It closes at 4pm on 31 October 2210")
  # end

  # test "closed consultation pending outcome" do
  #   setup_and_visit_content_item("closed_consultation")

  #   assert page.has_text?("Closed consultation")
  #   assert page.has_css?(".gem-c-notice", text: "We are analysing your feedback")

  #   assert page.has_text?("ran from")
  #   assert page.has_text?("2pm on 5 September 2016 to 4pm on 31 October 2016")
  # end

  # test "consultation outcome" do
  #   setup_and_visit_content_item("consultation_outcome")

  #   assert page.has_text?("Consultation outcome")
  #   assert page.has_css?(".gem-c-notice", text: "This consultation has concluded")
  #   assert page.has_css?("h2", text: "Original consultation")
  #   assert page.has_text?("ran from")
  #   assert page.has_text?("4pm on 20 April 2016 to 10:45pm on 13 July 2016")

  #   within ".consultation-outcome-detail" do
  #     assert page.has_text?(@content_item["details"]["final_outcome_detail"])
  #   end
  # end

  # test "public feedback" do
  #   setup_and_visit_content_item("consultation_outcome_with_feedback")

  #   assert page.has_text?("Detail of feedback received")
  #   within ".consultation-feedback" do
  #     assert page.has_text?("The majority of respondents agreed or strongly agreed with our proposals, which were:")
  #   end
  # end

  # test "renders consultation outcome attachments (as-is and directly)" do
  #   setup_and_visit_content_item("consultation_outcome", general_overrides)

  #   assert page.has_text?("Read the full outcome")
  #   within "#read-the-full-outcome" do
  #     assert page.has_text?("Setting the grade standards of new GCSEs in England – part 2")
  #   end

  #   setup_and_visit_content_item("consultation_outcome_with_featured_attachments")

  #   assert page.has_text?("Read the full outcome")
  #   within "#read-the-full-outcome" do
  #     assert page.has_text?("Equalities impact assessment: setting the grade standards of new GCSEs in England – part 2")
  #   end
  # end

  # test "shows pre-rendered public feedback documents" do
  #   setup_and_visit_content_item("consultation_outcome_with_feedback", general_overrides)

  #   assert page.has_text?("Feedback received")
  #   within "#feedback-received" do
  #     assert page.has_text?("Decisions on setting the grade standards of new GCSEs in England - part 2")
  #   end
  # end

  # test "renders public feedback document attachments" do
  #   setup_and_visit_content_item("consultation_outcome_with_featured_attachments")

  #   assert page.has_text?("Feedback received")
  #   within "#feedback-received" do
  #     assert page.has_text?("Analysis of responses to our consultation on setting the grade standards of new GCSEs in England – part 2")
  #   end
  # end

  # test "share urls" do
  #   setup_and_visit_content_item("open_consultation")
  #   assert page.has_css?("a", text: "Facebook")
  #   assert page.has_css?("a", text: "Twitter")
  # end

  # test "renders with the single page notification button on English language pages" do
  #   setup_and_visit_content_item("open_consultation")
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
  #   setup_and_visit_notification_exempt_page("open_consultation")
  #   assert_not page.has_css?(".gem-c-single-page-notification-button")
  # end

  # test "does not render the single page notification button on foreign language pages" do
  #   setup_and_visit_notification_exempt_page("open_consultation", "locale" => "cy")
  #   assert_not page.has_css?(".gem-c-single-page-notification-button")
  # end
end
