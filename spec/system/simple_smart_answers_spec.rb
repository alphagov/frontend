RSpec.describe "SimpleSmartAnswers" do
  before do
    @payload = {
      base_path: "/the-bridge-of-death",
      document_type: "simple_smart_answer",
      schema_name: "simple_smart_answer",
      title: "The Bridge of Death",
      description: "Cheery description about bridge of death",
      phase: "beta",
      public_updated_at: "2013-06-25T11:59:04+01:00",
      details: {
        start_button_text: "Start now",
        body:
          "<h2>STOP!</h2>\n\n<p>He who would cross the Bridge of Death<br />\nMust answer me<br />\nThese questions three<br />\nEre the other side he see.</p>\n",
        nodes: [
          {
            kind: "question",
            slug: "what-is-your-name",
            title: "What...is your name?",
            body: "<p class=\"small\">It's the old man from Scene 24!!</p>\n",
            options: [
              {
                label: "Sir Lancelot of Camelot",
                slug: "sir-lancelot-of-camelot",
                next_node: "what-is-your-favorite-colour",
              },
              {
                label: "Sir Robin of Camelot",
                slug: "sir-robin-of-camelot",
                next_node: "what-is-the-capital-of-assyria",
              },
              {
                label: "Sir Galahad of Camelot",
                slug: "sir-galahad-of-camelot",
                next_node: "what-is-your-favorite-colour",
              },
            ],
          },
          {
            kind: "question",
            slug: "what-is-the-capital-of-assyria",
            title: "What...is the capital of Assyria?",
            body: "\n",
            options: [
              {
                label: "I don't know THAT!!",
                slug: "i-don-t-know-that",
                next_node: "arrrrrghhhh",
              },
            ],
          },
          {
            kind: "question",
            slug: "what-is-your-favorite-colour",
            title: "What...is your favorite colour?",
            body: "\n",
            options: [
              { label: "Blue", slug: "blue", next_node: "right-off-you-go" },
              {
                label: "Blue... NO! YELLOOOOOOOOOOOOOOOOWWW!!!!",
                slug: "blue-no-yelloooooooooooooooowww",
                next_node: "arrrrrghhhh",
              },
            ],
          },
          {
            kind: "outcome",
            slug: "right-off-you-go",
            title: "Right, off you go.",
            body: "<p>Oh! Well, thank you. Thank you very much.</p>\n",
            options: [],
          },
          {
            kind: "outcome",
            slug: "arrrrrghhhh",
            title: "AAAAARRRRRRRRRRRRRRRRGGGGGHHH!!!!!!!",
            body: "\n",
            options: [],
          },
        ],
      },
    }
    stub_content_store_has_item("/the-bridge-of-death", @payload)
  end

  it "renders the start page correctly" do
    visit "/the-bridge-of-death"

    expect(page.status_code).to eq(200)
    within("head", visible: :all) do
      expect(page).to have_selector("title", exact_text: "The Bridge of Death - GOV.UK", visible: :all)
    end

    within("#content") do
      expect(page).to have_title("The Bridge of Death")
      within(".article-container") do
        within(".intro") do
          expect(page).to have_content("He who would cross the Bridge of Death Must answer me These questions three Ere the other side he see.")
          expect(page).to have_button_as_link("Start now", href: "/the-bridge-of-death/y", start: true, rel: "nofollow")
        end
      end
    end

    expect(page).to have_selector(".gem-c-phase-banner")
  end

  context "when previously a format with parts" do
    it "reroutes to the base slug if requested with part route" do
      visit "/the-bridge-of-death/old-part-route"

      expect(page).to have_current_path("/the-bridge-of-death", ignore_query: true)
    end
  end

  it "handles the flow correctly" do
    visit "/the-bridge-of-death"
    click_on("Start now")

    expect(page).to have_current_path("/the-bridge-of-death/y", ignore_query: true)

    within("head", visible: :all) do
      expect(page).to have_selector("title", exact_text: "What...is your name? - The Bridge of Death - GOV.UK", visible: :all)
      expect(page).to have_selector("meta[name=robots][content=noindex]", visible: :all)
    end

    within("#content") do
      within(".govuk-caption-l") do
        expect(page).to have_content("The Bridge of Death")
      end

      within(".gem-c-radio__heading-text") do
        expect(page).to have_content("What...is your name?")
      end
    end

    within("#content .govuk-form-group") do
      within(".govuk-fieldset__legend") do
        expect(page).to have_content("1. What...is your name?")
      end

      expect(page).to have_content("It's the old man from Scene 24!!")

      within(".govuk-radios") do
        expect(page).to have_field("Sir Lancelot of Camelot", type: "radio", with: "sir-lancelot-of-camelot")
        expect(page).to have_field("Sir Robin of Camelot", type: "radio", with: "sir-robin-of-camelot")
        expect(page).to have_field("Sir Galahad of Camelot", type: "radio", with: "sir-galahad-of-camelot")
        options = page.all(:xpath, ".//label").map(&:text).map(&:strip)
        expect(options).to eq(
          [
            "Sir Lancelot of Camelot",
            "Sir Robin of Camelot",
            "Sir Galahad of Camelot",
          ],
        )
      end
    end

    click_on("Next step")

    within("head", visible: :all) do
      expect(page).to have_selector("title", exact_text: "Error - What...is your name? - The Bridge of Death - GOV.UK", visible: :all)
    end

    within("#content .govuk-form-group--error") do
      expect(page).to have_selector(".gem-c-error-message.govuk-error-message", exact_text: "Error: Please answer this question")
    end

    within(".gem-c-error-summary.govuk-error-summary") do
      expect(page).to have_selector(".govuk-error-summary__title", exact_text: "There is a problem")
      expect(page).to have_selector(".gem-c-error-summary__list-item", exact_text: "Please answer this question")
    end

    choose("Sir Lancelot of Camelot")
    click_on("Next step")

    expect(page).to have_current_path("/the-bridge-of-death/y/sir-lancelot-of-camelot", ignore_query: true)

    within(".gem-c-heading + .govuk-body") do
      expect(page).to have_link("Start again", href: "/the-bridge-of-death")
    end

    within("head", visible: :all) do
      expect(page).to have_selector("title", exact_text: "What...is your favorite colour? - The Bridge of Death - GOV.UK", visible: :all)
      expect(page).to have_selector("meta[name=robots][content=noindex]", visible: :all)
    end

    within(".govuk-summary-list") do
      within(".govuk-summary-list__row") do
        expect(page).to have_content("1. What...is your name?")
      end

      within(".govuk-summary-list__value") do
        expect(page).to have_content("Sir Lancelot of Camelot")
      end

      within(".govuk-summary-list__actions") do
        expect(page).to have_link("Change", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot")
      end
    end

    within(".govuk-fieldset__legend") do
      expect(page).to have_content("2. What...is your favorite colour?")
    end

    within(".govuk-fieldset") do
      expect(page).to have_field("Blue", type: "radio", with: "blue")
      expect(page).to have_field("Blue... NO! YELLOOOOOOOOOOOOOOOOWWW!!!!", type: "radio", with: "blue-no-yelloooooooooooooooowww")
      options = page.all(:xpath, ".//label").map(&:text).map(&:strip)
      expect(options).to eq(["Blue", "Blue... NO! YELLOOOOOOOOOOOOOOOOWWW!!!!"])
    end

    choose("Blue")
    click_on("Next step")

    expect(page).to have_current_path("/the-bridge-of-death/y/sir-lancelot-of-camelot/blue", ignore_query: true)

    within(".gem-c-heading + .govuk-body") do
      expect(page).to have_link("Start again", href: "/the-bridge-of-death")
    end

    within("head", visible: :all) do
      expect(page).to have_selector("title", text: "Right, off you go. - The Bridge of Death - GOV.UK", visible: :all)
      expect(page).to have_selector("meta[name=robots][content=noindex]", visible: :all)
    end

    within(".govuk-summary-list") do
      within(".govuk-summary-list__row:nth-child(1)") do
        within(".govuk-summary-list__key") do
          expect(page).to have_content("1. What...is your name?")
        end

        within(".govuk-summary-list__value") do
          expect(page).to have_content("Sir Lancelot of Camelot")
        end

        within(".govuk-summary-list__actions") do
          expect(page).to have_link("Change", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot")
        end
      end

      within(".govuk-summary-list__row:nth-child(2)") do
        within(".govuk-summary-list__key") do
          expect(page).to have_content("2. What...is your favorite colour?")
        end

        within(".govuk-summary-list__value") do
          expect(page).to have_content("Blue")
        end

        within(".govuk-summary-list__actions") do
          expect(page).to have_link("Change", href: "/the-bridge-of-death/y/sir-lancelot-of-camelot?previous_response=blue")
        end
      end
    end

    within("[data-module='ga4-auto-tracker']") do
      within("h1") { expect(page).to have_content("Right, off you go.") }
      expect(page).to have_content("Oh! Well, thank you. Thank you very much.")
    end
  end

  it "loads the appropriate GA4 attributes at each step" do
    visit "/the-bridge-of-death"

    expect(page).to have_selector("[data-ga4-link='{\"event_name\":\"form_start\",\"type\":\"simple smart answer\",\"section\":\"start page\",\"action\":\"start\",\"tool_name\":\"The Bridge of Death\"}']")

    click_on("Start now")

    expect(page).to have_current_path("/the-bridge-of-death/y", ignore_query: true)
    expect(page).not_to have_selector("[data-ga4-link='{\"event_name\":\"form_start\",\"type\":\"simple smart answer\",\"section\":\"start page\",\"action\":\"start\",\"tool_name\":\"The Bridge of Death\"}']")
    expect(page).to have_selector("[data-module='ga4-form-tracker']")
    expect(page).to have_selector("[data-ga4-form='{\"event_name\":\"form_response\",\"type\":\"simple smart answer\",\"section\":\"What...is your name?\",\"action\":\"next step\",\"tool_name\":\"The Bridge of Death\"}']")

    choose("Sir Lancelot of Camelot")
    click_on("Next step")

    expect(page).to have_current_path("/the-bridge-of-death/y/sir-lancelot-of-camelot", ignore_query: true)
    expect(page).not_to have_selector("[data-ga4-link='{\"event_name\":\"form_start\",\"type\":\"simple smart answer\",\"section\":\"start page\",\"action\":\"start\",\"tool_name\":\"The Bridge of Death\"}']")
    expect(page).to have_selector("[data-module='ga4-form-tracker']")
    expect(page).to have_selector("[data-ga4-form='{\"event_name\":\"form_response\",\"type\":\"simple smart answer\",\"section\":\"What...is your favorite colour?\",\"action\":\"next step\",\"tool_name\":\"The Bridge of Death\"}']")
    expect(page).to have_selector("[data-ga4-link='{\"event_name\":\"form_start_again\",\"type\":\"simple smart answer\",\"section\":\"What...is your favorite colour?\",\"action\":\"start again\",\"tool_name\":\"The Bridge of Death\"}']")
    expect(page).to have_selector("[data-ga4-link='{\"event_name\":\"form_change_response\",\"type\":\"simple smart answer\",\"section\":\"What...is your name?\",\"action\":\"change response\",\"tool_name\":\"The Bridge of Death\"}']")
  end

  it "loads the appropriate GA4 data attributes when there is an error" do
    visit "/the-bridge-of-death"
    click_on("Start now")

    expect(page).to have_current_path("/the-bridge-of-death/y", ignore_query: true)

    click_on("Next step")

    expect(page).to have_selector("[data-module='ga4-auto-tracker govuk-error-summary']")
    expect(page).to have_selector("[data-ga4-auto='{\"event_name\":\"form_error\",\"type\":\"simple smart answer\",\"text\":\"Please answer this question\",\"section\":\"What...is your name?\",\"action\":\"error\",\"tool_name\":\"The Bridge of Death\"}']")
  end

  it "tells GA when we reach the end of the smart answer" do
    visit "/the-bridge-of-death"
    click_on("Start now")

    expect(page).to have_current_path("/the-bridge-of-death/y", ignore_query: true)
    expect(page).not_to have_selector("[data-module='ga4-auto-tracker']")

    choose("Sir Lancelot of Camelot")
    click_on("Next step")

    expect(page).to have_current_path("/the-bridge-of-death/y/sir-lancelot-of-camelot", ignore_query: true)
    expect(page).not_to have_selector("[data-module='ga4-auto-tracker']")

    choose("Blue")
    click_on("Next step")

    expect(page).to have_current_path("/the-bridge-of-death/y/sir-lancelot-of-camelot/blue", ignore_query: true)
    expect(page).to have_selector("[data-module='ga4-auto-tracker']")
    expect(page).to have_selector("[data-ga4-auto='{\"event_name\":\"form_complete\",\"type\":\"simple smart answer\",\"section\":\"Right, off you go.\",\"action\":\"complete\",\"tool_name\":\"The Bridge of Death\",\"text\":\"right-off-you-go\"}']")
    expect(page).to have_selector("[data-ga4-link='{\"event_name\":\"information_click\",\"type\":\"simple smart answer\",\"section\":\"Right, off you go.\",\"action\":\"information click\",\"tool_name\":\"The Bridge of Death\"}']")
    expect(page).to have_selector("[data-ga4-link='{\"event_name\":\"form_start_again\",\"type\":\"simple smart answer\",\"section\":\"Right, off you go.\",\"action\":\"start again\",\"tool_name\":\"The Bridge of Death\"}']")
    expect(page).to have_selector("[data-ga4-link='{\"event_name\":\"form_change_response\",\"type\":\"simple smart answer\",\"section\":\"What...is your name?\",\"action\":\"change response\",\"tool_name\":\"The Bridge of Death\"}']")
    expect(page).to have_selector("[data-ga4-link='{\"event_name\":\"form_change_response\",\"type\":\"simple smart answer\",\"section\":\"What...is your favorite colour?\",\"action\":\"change response\",\"tool_name\":\"The Bridge of Death\"}']")
  end

  it "adds hidden token param when fact checking" do
    token = "5UP3R_53CR3T_F4CT_CH3CK_T0k3N"
    visit "/the-bridge-of-death?token=#{token}"
    click_on("Start now")

    expect(page.current_url).to eq("http://www.example.com/the-bridge-of-death/y?token=#{token}")
    expect(page).to have_selector("input[value='#{token}']", visible: false)
  end

  it "allows changing an answer" do
    visit "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"
    within(".govuk-summary-list .govuk-summary-list__row:nth-child(2)") do
      click_on("Change")
    end

    expect(page).to have_current_path("/the-bridge-of-death/y/sir-lancelot-of-camelot", ignore_query: true)

    within(".govuk-summary-list") do
      expect(page).to have_selector(".govuk-summary-list__row", count: 1)

      within(".govuk-summary-list__row") do
        within(".govuk-summary-list__key") do
          expect(page).to have_content("1. What...is your name?")
        end

        within(".govuk-summary-list__value") do
          expect(page).to have_content("Sir Lancelot of Camelot")
        end

        within(".govuk-summary-list__actions") do
          expect(page).to have_link("Change", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot")
        end
      end
    end

    within("#content .govuk-form-group") do
      within(".govuk-fieldset__legend") do
        expect(page).to have_content("2. What...is your favorite colour?")
      end

      within(".govuk-radios") do
        expect(page).to have_field("Blue", type: "radio", with: "blue", checked: true)
      end
    end

    choose("Blue... NO! YELLOOOOOOOOOOOOOOOOWWW!!!!")
    click_on("Next step")

    expect(page).to have_current_path("/the-bridge-of-death/y/sir-lancelot-of-camelot/blue-no-yelloooooooooooooooowww", ignore_query: true)
    expect(page).to have_content("AAAAARRRRRRRRRRRRRRRRGGGGGHHH!!!!!!!")
  end

  it "handles invalid responses in the url param correctly" do
    visit "/the-bridge-of-death/y/sir-lancelot-of-camelot/ultramarine"

    within(".govuk-summary-list") do
      expect(page).to have_selector(".govuk-summary-list__row", count: 1)

      within(".govuk-summary-list__row") do
        within(".govuk-summary-list__key") do
          expect(page).to have_content("1. What...is your name?")
        end

        within(".govuk-summary-list__value") do
          expect(page).to have_content("Sir Lancelot of Camelot")
        end

        within(".govuk-summary-list__actions") do
          expect(page).to have_link("Change", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot")
        end
      end
    end

    within(".govuk-fieldset") do
      within(".govuk-fieldset__legend") do
        expect(page).to have_content("What...is your favorite colour?")
      end
      expect(page).to have_selector(".govuk-error-message", text: "Please answer this question")
    end

    choose("Blue")
    click_on("Next step")

    expect(page).to have_current_path("/the-bridge-of-death/y/sir-lancelot-of-camelot/blue", ignore_query: true)
    expect(page).to have_selector(".govuk-summary-list .govuk-summary-list__row", count: 2)
    expect(page).to have_content("Right, off you go")
  end

  it "handles empty form submissions correctly" do
    visit "/the-bridge-of-death/y/sir-lancelot-of-camelot"

    within("#content .govuk-form-group") do
      within(".govuk-fieldset__legend") do
        expect(page).to have_content("2. What...is your favorite colour?")
      end
      expect(page).not_to have_selector(".govuk-error-message", text: "Please answer this question")
    end

    click_on("Next step")

    within("#content .govuk-form-group") do
      within(".govuk-fieldset__legend") do
        expect(page).to have_content("2. What...is your favorite colour?")
      end
      expect(page).to have_selector(".govuk-error-message", text: "Please answer this question")
    end
  end

  it "handles invalid form submissions correctly" do
    visit "/the-bridge-of-death/y/sir-lancelot-of-camelot?response=ultramarine"

    within(".govuk-summary-list") do
      expect(page).to have_selector(".govuk-summary-list__row", count: 1)
      within(".govuk-summary-list__row") do
        within(".govuk-summary-list__key") do
          expect(page).to have_content("1. What...is your name?")
        end

        within(".govuk-summary-list__value") do
          expect(page).to have_content("Sir Lancelot of Camelot")
        end

        within(".govuk-summary-list__actions") do
          expect(page).to have_link("Change", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot")
        end
      end
    end

    within("#content .govuk-form-group") do
      within(".govuk-fieldset__legend") do
        expect(page).to have_content("2. What...is your favorite colour?")
      end

      expect(page).to have_selector(".govuk-error-message", text: "Please answer this question")
    end

    choose("Blue")
    click_on("Next step")

    expect(page).to have_current_path("/the-bridge-of-death/y/sir-lancelot-of-camelot/blue", ignore_query: true)
    expect(page).to have_selector(".govuk-summary-list .govuk-summary-list__row", count: 2)
    expect(page).to have_content("Right, off you go")
  end

  it "handles invalid url params combined with form submissions correctly" do
    visit "/the-bridge-of-death/y/sir-lancelot-of-camelot/ultramarine?response=blue"

    within(".govuk-summary-list") do
      expect(page).to have_selector(".govuk-summary-list__row", count: 1)
      within(".govuk-summary-list__row") do
        within(".govuk-summary-list__key") do
          expect(page).to have_content("1. What...is your name?")
        end

        within(".govuk-summary-list__value") do
          expect(page).to have_content("Sir Lancelot of Camelot")
        end

        within(".govuk-summary-list__actions") do
          expect(page).to have_link("Change", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot")
        end
      end
    end

    within("#content .govuk-form-group") do
      within(".govuk-fieldset__legend") do
        expect(page).to have_content("2. What...is your favorite colour?")
      end
      expect(page).to have_selector(".govuk-error-message", text: "Please answer this question")
    end

    choose("Blue")
    click_on("Next step")

    expect(page).to have_current_path("/the-bridge-of-death/y/sir-lancelot-of-camelot/blue", ignore_query: true)
    expect(page).to have_selector(".govuk-summary-list .govuk-summary-list__row", count: 2)
    expect(page).to have_content("Right, off you go")
  end
end
