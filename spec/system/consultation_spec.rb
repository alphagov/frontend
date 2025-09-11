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

      it "displays link to external consultations" do
        within(".gem-c-summary-banner") do
          expect(page).to have_css("a[href=\"#{content_store_response['details']['held_on_another_website_url']}\"]", text: "another website")
        end
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

    context "when it renders share urls" do
      it "displays the social media links" do
        within(".gem-c-share-links") do
          expect(page).to have_css("h2", text: "Share this page")
          expect(page).to have_css("a", text: "Facebook")
          expect(page).to have_css("a", text: "Twitter")
        end
      end
    end

    context "when it renders the single page notification button" do
      it "displays the button on English language pages" do
        buttons = page.find_all(".gem-c-single-page-notification-button")

        expect(buttons.count).to eq(2)

        buttons.each do
          expect(page).to have_css(".gem-c-single-page-notification-button", text: "Get emails about this page")
        end
      end

      it "does not render the button on foreign language pages" do
        content_store_response["locale"] = "cy"
        stub_content_store_has_item("/government/consultations/postgraduate-doctoral-loans", content_store_response)
        visit "/government/consultations/postgraduate-doctoral-loans"

        expect(page).not_to have_css(".gem-c-single-page-notification-button")
      end

      it "does not render the button on exempt pages" do
        content_store_response["content_id"] = "c5c8d3cd-0dc2-4ca3-8672-8ca0a6e92165"
        stub_content_store_has_item("/government/consultations/postgraduate-doctoral-loans", content_store_response)
        visit "/government/consultations/postgraduate-doctoral-loans"

        expect(page).not_to have_css(".gem-c-single-page-notification-button")
      end
    end
  end

  context "when visiting an open consultation page" do
    let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "open_consultation") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "displays the consultation status" do
      within(".gem-c-heading__context") do
        expect(page).to have_content("Open consultation")
      end
    end

    it "displays when the consultation closes" do
      within(".gem-c-summary-banner") do
        expect(page).to have_css(".gem-c-summary-banner__text", text: "This consultation closes at 3pm on 16 December 2216")
      end
    end

    it "links to external consultation url if available" do
      expect(page).to have_css(".gem-c-summary-banner", text: "This consultation is being held on")

      expect(page).to have_link("another website", href: content_store_response.dig("details", "held_on_another_website_url"))
    end
  end

  context "when visiting an unopened consultation page" do
    let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "unopened_consultation") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "displays the consultation status" do
      within(".gem-c-heading__context") do
        expect(page).to have_content("Consultation")
      end
    end

    context "when it displays the notice banner" do
      it "displays the title" do
        within(".gem-c-notice") do
          expect(page).to have_css("h2", text: "This consultation isn't open yet")
        end
      end

      it "displays the opening time" do
        within(".gem-c-notice") do
          expect(page).to have_css(".gem-c-notice__description", text: "This consultation opens at 1pm on 5 October 2200")
        end
      end

      it "includes 'on' if opening time is 12am" do
        content_store_response["details"]["opening_date"] = "2016-11-04T00:00:00+00:00"
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path

        within(".gem-c-notice") do
          expect(page).to have_css(".gem-c-notice__description", text: "This consultation opens on 4 November 2016")
        end
      end
    end

    context "when it displays the blue summary box" do
      it "displays when the consultation closes" do
        within(".gem-c-summary-banner") do
          expect(page).to have_css(".gem-c-summary-banner__text", text: "It closes at 4pm on 31 October 2210")
        end
      end

      it "links to external consultation url if available" do
        content_store_response["details"]["held_on_another_website_url"] = "https://consult.education.gov.uk/part-time-maintenance-loans/post-graduate-doctoral-loans/"
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path

        within(".gem-c-summary-banner") do
          expect(page).to have_text("This consultation is being held on")

          expect(page).to have_link("another website", href: content_store_response.dig("details", "held_on_another_website_url"))
        end
      end
    end

    it "does not display ways to respond" do
      expect(page).not_to have_css(".consultation-ways-to-respond")
    end
  end

  context "when visiting a closed consultation page" do
    let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "closed_consultation") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "displays the consultation status" do
      within(".gem-c-heading__context") do
        expect(page).to have_content("Closed consultation")
      end
    end

    context "when it displays the notice banner" do
      it "displays the title" do
        within(".gem-c-notice") do
          expect(page).to have_css(".gem-c-notice__title", text: "We are analysing your feedback")
        end
      end

      it "displays the text" do
        within(".gem-c-notice") do
          expect(page).to have_css(".gem-c-notice__description", text: "Visit this page again soon to download the outcome to this public feedback.")
        end
      end
    end

    context "when it displays the blue summary box" do
      it "displays when the consultation ran" do
        within(".gem-c-summary-banner") do
          expect(page).to have_css(".gem-c-summary-banner__text", text: "This consultation ran from")
          expect(page).to have_css(".gem-c-summary-banner__text", text: "2pm on 5 September 2016 to 4pm on 31 October 2016")
        end
      end

      it "links to external consultation page if available" do
        content_store_response["details"]["held_on_another_website_url"] = "https://consult.education.gov.uk/part-time-maintenance-loans/post-graduate-doctoral-loans/"
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path

        within(".gem-c-summary-banner") do
          expect(page).to have_text("This consultation was held on")

          expect(page).to have_link("another website", href: content_store_response.dig("details", "held_on_another_website_url"))
        end
      end
    end

    it "does not display ways to respond" do
      expect(page).not_to have_css(".call-for-evidence-ways-to-respond")
    end
  end

  context "when visiting a consultation outcome page" do
    let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "consultation_outcome") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "displays the consultation status" do
      within(".gem-c-heading__context") do
        expect(page).to have_content("Consultation outcome")
      end
    end

    it "displays the status in the notice banner" do
      within(".gem-c-notice") do
        expect(page).to have_css(".gem-c-notice__title", text: "This consultation has concluded")
      end
    end

    it "does not display a description in the notice banner" do
      within(".gem-c-notice") do
        expect(page).not_to have_css(".gem-c-notice__description")
      end
    end

    it "displays the 'Original consultation' heading" do
      expect(page).to have_css("h2", text: "Original consultation")
    end

    it "displays the outcome detail" do
      within(".consultation-outcome-detail") do
        expect(page).to have_content(content_store_response["details"]["final_outcome_detail"])
      end
    end

    context "when it displays the blue summary box" do
      it "displays when the consultation ran" do
        within(".gem-c-summary-banner") do
          expect(page).to have_css(".gem-c-summary-banner__text", text: "This consultation ran from")
          expect(page).to have_css(".gem-c-summary-banner__text", text: "4pm on 20 April 2016 to 10:45pm on 13 July 2016")
        end
      end

      it "links to external consultation url if available" do
        content_store_response["details"]["held_on_another_website_url"] = "https://consult.education.gov.uk/part-time-maintenance-loans/post-graduate-doctoral-loans/"
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path

        within(".gem-c-summary-banner") do
          expect(page).to have_text("This consultation was held on")

          expect(page).to have_link("another website", href: content_store_response.dig("details", "held_on_another_website_url"))
        end
      end
    end

    context "when rendering public feedback" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "consultation_outcome_with_feedback") }
      let(:base_path) { content_store_response.fetch("base_path") }

      before do
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
      end

      it "displays feedback title" do
        expect(page).to have_css("h2", text: "Detail of feedback received")
      end

      it "displays feedback text" do
        within(".consultation-feedback") do
          expect(page).to have_text("The majority of respondents agreed or strongly agreed with our proposals, which were:")
        end
      end
    end

    context "when rendering full outcome details" do
      let(:content_store_response) { GovukSchemas::Example.find("consultation", example_name: "consultation_outcome_with_featured_attachments") }
      let(:base_path) { content_store_response.fetch("base_path") }

      before do
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
      end

      it "displays 'Read the full outcome' heading" do
        within("#read-the-full-outcome") do
          expect(page).to have_css("h2", text: "Read the full outcome")
        end
      end

      it "renders consultation outcome attachments" do
        within("#read-the-full-outcome") do
          expect(page).to have_text("Equalities impact assessment: setting the grade standards of new GCSEs in England – part 2")
        end
      end

      it "renders public feedback document attachments" do
        assert page.has_text?("Feedback received")

        within "#feedback-received" do
          expect(page).to have_text("Analysis of responses to our consultation on setting the grade standards of new GCSEs in England – part 2")
        end
      end
    end

    it "does not display ways to respond" do
      expect(page).not_to have_css(".call-for-evidence-ways-to-respond")
    end
  end
end
