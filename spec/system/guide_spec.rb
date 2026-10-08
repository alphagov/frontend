RSpec.describe "Guide" do
  include SchemaOrgHelpers
  include GovukAbTesting::RspecHelpers

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

      expect(page).to have_css(".gem-c-contents-list li", count: parts_size)
      expect(page).to have_css(".gem-c-contents-list li", text: content_store_response["details"]["parts"].first["title"])
      expect(page).not_to have_css(".gem-c-contents-list li a", text: content_store_response["details"]["parts"].first["title"])

      content_store_response["details"]["parts"][1..parts_size].each do |part|
        expect(page).to have_css(".gem-c-contents-list li a[href*=\"#{part['slug']}\"]", text: part["title"])
      end

      expect(page).to have_css(".govuk-pagination")
      expect(page).to have_css('.govuk-link.govuk-link--no-visited-state[href$="/print"]', text: I18n.t("multi_page.print_entire_guide"))

      expect(page).to have_link("Next", href: "#{base_path}/#{content_store_response['details']['parts'][1]['slug']}")
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

    context "when a draft access token is supplied" do
      before do
        visit "#{base_path}?token=some_token"
      end

      it "appends draft access tokens to part links within navigation" do
        expect(page).to have_selector('.gem-c-contents-list a[href$="?token=some_token"]')
      end
    end
  end

  context "when visiting the postal vote video test" do
    let(:content_store_response) do
      GovukSchemas::Example.find("guide", example_name: "guide").tap do |content_item|
        content_item["base_path"] = "/how-to-vote"
        content_item["title"] = "How to vote"
        content_item["details"]["parts"] = [
          {
            "body" => other_guide_page_content,
            "slug" => "overview",
            "title" => "Overview",
          },
          {
            "body" => existing_postal_vote_content,
            "slug" => "postal-voting",
            "title" => "Voting by post",
          },
        ]
      end
    end
    let(:youtube_url) { "https://www.youtube.com/watch?v=Abl8WliyXSc" }
    let(:other_youtube_url) { "https://www.youtube.com/watch?v=other-video" }
    let(:other_guide_page_content) do
      <<~HTML
        <p><a href="#{other_youtube_url}">Video on another guide page</a></p>
        <p>This content belongs to another guide page.</p>
      HTML
    end
    let(:existing_postal_vote_content) do
      <<~HTML
        <p>You must apply for a postal vote if you want to vote by post, for example if:</p>
        <ul>
          <li>you're away from home</li>
          <li>you're abroad and want to vote in England, Scotland or Wales</li>
        </ul>
        <h2>Apply for a postal vote</h2>
        <p>This content comes from Publisher and must remain unchanged.</p>
      HTML
    end

    before do
      stub_content_store_has_item("/how-to-vote", content_store_response)
    end

    it "shows only the Publisher content for variant A" do
      with_variant(PostalVoteVideo: "A") do
        visit "/how-to-vote/postal-voting"

        expect(page).not_to have_link("What is a postal vote?", href: youtube_url)
        expect(page).not_to have_css("h2", text: "What is a postal vote?")
        expect(page).not_to have_content("This video explains what postal voting is")
        expect(page).not_to have_css(".govuk-details__summary", text: "Transcript")
        expect(page).to have_content("You must apply for a postal vote")
        expect(page).to have_content("This content comes from Publisher and must remain unchanged.")
        expect(page).to have_css(".gem-c-govspeak.js-disable-youtube")
        expect(page).not_to have_css(".app-c-postal-vote-video")
      end
    end

    it "adds the hardcoded video content for variant B" do
      with_variant(PostalVoteVideo: "B") do
        visit "/how-to-vote/postal-voting"

        expect(page).to have_link("What is a postal vote?", href: youtube_url)
        expect(page).to have_css("h2#what-is-a-postal-vote", text: "What is a postal vote?")
        expect(page).to have_content("This video explains what postal voting is")
        expect(page).to have_content("GOV.UK • 1 minutes 48 seconds")
        expect(page).to have_css(".app-c-postal-vote-video .govuk-details__summary", text: "Transcript")
        expect(page).to have_css(
          ".app-c-postal-vote-video .govuk-details__text",
          text: "A postal vote allows you to vote without having to visit a polling station.",
          visible: :all,
        )
        expect(page).to have_css(
          ".app-c-postal-vote-video .govuk-details__text",
          text: "To apply, search ‘apply postal vote’ on GOV.UK.",
          visible: :all,
        )
        expect(page).to have_content("You must apply for a postal vote")
        expect(page).to have_content("This content comes from Publisher and must remain unchanged.")
        expect(page).not_to have_css(".gem-c-govspeak.js-disable-youtube")
        expect(page).to have_css(".app-c-postal-vote-video")
      end
    end

    it "shows only the Publisher content for variant Z" do
      with_variant(PostalVoteVideo: "Z") do
        visit "/how-to-vote/postal-voting"

        expect(page).not_to have_link("What is a postal vote?", href: youtube_url)
        expect(page).not_to have_css("h2", text: "What is a postal vote?")
        expect(page).not_to have_content("This video explains what postal voting is")
        expect(page).not_to have_css(".govuk-details__summary", text: "Transcript")
        expect(page).to have_content("You must apply for a postal vote")
        expect(page).to have_content("This content comes from Publisher and must remain unchanged.")
        expect(page).to have_css(".gem-c-govspeak.js-disable-youtube")
        expect(page).not_to have_css(".app-c-postal-vote-video")
      end
    end

    it "adds the hardcoded video content in draft preview without applying the A/B test" do
      setup_ab_variant("PostalVoteVideo", "A")

      visit "/how-to-vote/postal-voting?token=some-token"

      expect(page).to have_link("What is a postal vote?", href: youtube_url)
      expect(page).to have_css("h2#what-is-a-postal-vote", text: "What is a postal vote?")
      expect(page).to have_css(".app-c-postal-vote-video .govuk-details__summary", text: "Transcript")
      expect(page).to have_css(
        ".app-c-postal-vote-video .govuk-details__text",
        text: "A postal vote allows you to vote without having to visit a polling station.",
        visible: :all,
      )
      expect(page).to have_content("You must apply for a postal vote")
      expect(page).not_to have_css(".gem-c-govspeak.js-disable-youtube")
      expect(page).to have_css(".app-c-postal-vote-video")
      assert_response_not_modified_for_ab_test("PostalVoteVideo")
      expect(page).not_to have_css('meta[name="govuk:ab-test"][content^="PostalVoteVideo:"]', visible: :all)
    end

    it "does not add hardcoded content or apply the A/B test on other guide pages" do
      setup_ab_variant("PostalVoteVideo", "A")

      visit "/how-to-vote"

      expect(page).to have_link("Video on another guide page", href: other_youtube_url)
      expect(page).to have_content("This content belongs to another guide page.")
      expect(page).not_to have_link("What is a postal vote?", href: youtube_url)
      expect(page).not_to have_css("h2", text: "What is a postal vote?")
      expect(page).not_to have_css(".app-c-postal-vote-video")
      expect(page).not_to have_css(".govuk-details__summary", text: "Transcript")
      assert_response_not_modified_for_ab_test("PostalVoteVideo")
      expect(page).not_to have_css('meta[name="govuk:ab-test"][content^="PostalVoteVideo:"]', visible: :all)
    end

    it "does not add the hardcoded content to the printable guide" do
      setup_ab_variant("PostalVoteVideo", "B")

      visit "/how-to-vote/print"

      expect(page).not_to have_link("What is a postal vote?", href: youtube_url)
      expect(page).not_to have_css("h2", text: "What is a postal vote?")
      expect(page).not_to have_css(".app-c-postal-vote-video")
      expect(page).to have_content("You must apply for a postal vote")
      assert_response_not_modified_for_ab_test("PostalVoteVideo")
    end
  end

  # Adding in some extra checks to ensure the other video on the child benefit guide
  # is not affected by the postal vote video A/B test

  context "when visiting the Child Benefit guide" do
    let(:youtube_url) { "https://www.youtube.com/watch?v=child-benefit" }
    let(:content_store_response) do
      GovukSchemas::Example.find("guide", example_name: "guide").tap do |content_item|
        content_item["base_path"] = "/child-benefit"
        content_item["title"] = "Child Benefit"
        content_item["details"]["parts"] = [
          {
            "body" => %(<p><a href="#{youtube_url}">Child Benefit video</a></p>),
            "slug" => "how-to-claim",
            "title" => "How to claim",
          },
        ]
      end
    end

    before do
      stub_content_store_has_item("/child-benefit", content_store_response)
      visit "/child-benefit/how-to-claim"
    end

    it "preserves its existing video behaviour without adding postal vote content" do
      expect(page).to have_link("Child Benefit video", href: youtube_url)
      expect(page).not_to have_link("What is a postal vote?", href: "https://www.youtube.com/watch?v=Abl8WliyXSc")
      expect(page).not_to have_css(".gem-c-govspeak.js-disable-youtube")
      expect(page).not_to have_css(".app-c-postal-vote-video")
      expect(page).not_to have_css(".govuk-details__summary", text: "Transcript")
      assert_response_not_modified_for_ab_test("PostalVoteVideo")
    end
  end
end
