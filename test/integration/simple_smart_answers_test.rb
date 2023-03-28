require "integration_test_helper"

class SimpleSmartAnswersTest < ActionDispatch::IntegrationTest
  setup do
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
        body: "<h2>STOP!</h2>\n\n<p>He who would cross the Bridge of Death<br />\nMust answer me<br />\nThese questions three<br />\nEre the other side he see.</p>\n",
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
              {
                label: "Blue",
                slug: "blue",
                next_node: "right-off-you-go",
              },
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

  should "render the start page correctly" do
    visit "/the-bridge-of-death"

    assert_equal 200, page.status_code

    within "head", visible: :all do
      assert page.has_selector?(
        "title",
        exact_text: "The Bridge of Death - GOV.UK",
        visible: :all,
      )
    end

    within "#content" do
      assert_has_component_title "The Bridge of Death"

      within ".article-container" do
        within ".intro" do
          assert_page_has_content("He who would cross the Bridge of Death Must answer me These questions three Ere the other side he see.")
          assert_has_button_as_link(
            "Start now",
            href: "/the-bridge-of-death/y",
            start: true,
            rel: "nofollow",
          )
        end
      end
    end

    assert page.has_selector?(".gem-c-phase-banner")
  end

  context "when previously a format with parts" do
    should "reroute to the base slug if requested with part route" do
      visit "/the-bridge-of-death/old-part-route"
      assert_current_url "/the-bridge-of-death"
    end
  end

  should "handle the flow correctly" do
    visit "/the-bridge-of-death"

    click_on "Start now"

    assert_current_url "/the-bridge-of-death/y"

    within "head", visible: :all do
      assert page.has_selector?(
        "title",
        exact_text: "What...is your name? - The Bridge of Death - GOV.UK",
        visible: :all,
      )

      assert page.has_selector?(
        "meta[name=robots][content=noindex]",
        visible: :all,
      )
    end

    within "#content" do
      within ".govuk-caption-l" do
        assert_page_has_content("The Bridge of Death")
      end
      within ".gem-c-radio__heading-text" do
        assert_page_has_content("What...is your name?")
      end
    end

    within "#content .govuk-form-group" do
      within ".govuk-fieldset__legend" do
        assert_page_has_content "1. What...is your name?"
      end
      assert_page_has_content "It's the old man from Scene 24!!"
      within ".govuk-radios" do
        assert page.has_field?("Sir Lancelot of Camelot", type: "radio", with: "sir-lancelot-of-camelot")
        assert page.has_field?("Sir Robin of Camelot", type: "radio", with: "sir-robin-of-camelot")
        assert page.has_field?("Sir Galahad of Camelot", type: "radio", with: "sir-galahad-of-camelot")
        # Assert they're in the correct order
        options = page.all(:xpath, ".//label").map(&:text).map(&:strip)
        assert_equal ["Sir Lancelot of Camelot", "Sir Robin of Camelot", "Sir Galahad of Camelot"], options
      end
    end

    # Submitting the form without choosing an option must show a validation
    # error.
    click_on "Next step"

    within "head", visible: :all do
      assert page.has_selector?(
        "title",
        exact_text: "Error - What...is your name? - The Bridge of Death - GOV.UK",
        visible: :all,
      )
    end

    within "#content .govuk-form-group--error" do
      assert page.has_selector?(
        ".gem-c-error-message.govuk-error-message",
        exact_text: "Error: Please answer this question",
      )
    end

    within ".gem-c-error-summary.govuk-error-summary" do
      assert page.has_selector?(
        ".govuk-error-summary__title",
        exact_text: "There is a problem",
      )

      assert page.has_selector?(
        ".gem-c-error-summary__list-item",
        exact_text: "Please answer this question",
      )
    end

    # Choosing an option allows the simple smart answer to move onto the next
    # step.
    choose "Sir Lancelot of Camelot"
    click_on "Next step"

    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot"

    within(".gem-c-heading + .govuk-body") do
      assert page.has_link?("Start again", href: "/the-bridge-of-death")
    end

    within "head", visible: :all do
      assert page.has_selector?(
        "title",
        exact_text: "What...is your favorite colour? - The Bridge of Death - GOV.UK",
        visible: :all,
      )

      assert page.has_selector?(
        "meta[name=robots][content=noindex]",
        visible: :all,
      )
    end

    within ".govuk-summary-list" do
      within ".govuk-summary-list__row" do
        assert_page_has_content "1. What...is your name?"
      end
      within(".govuk-summary-list__value") { assert_page_has_content "Sir Lancelot of Camelot" }
      within(".govuk-summary-list__actions") { assert page.has_link?("Change", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
    end

    within ".govuk-fieldset__legend" do
      assert_page_has_content "2. What...is your favorite colour?"
    end
    within ".govuk-fieldset" do
      assert page.has_field?("Blue", type: "radio", with: "blue")
      assert page.has_field?("Blue... NO! YELLOOOOOOOOOOOOOOOOWWW!!!!", type: "radio", with: "blue-no-yelloooooooooooooooowww")
      # Assert they're in the correct order.
      options = page.all(:xpath, ".//label").map(&:text).map(&:strip)
      assert_equal ["Blue", "Blue... NO! YELLOOOOOOOOOOOOOOOOWWW!!!!"], options
    end

    choose "Blue"
    click_on "Next step"

    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"

    within(".gem-c-heading + .govuk-body") do
      assert page.has_link?("Start again", href: "/the-bridge-of-death")
    end

    within "head", visible: :all do
      assert page.has_selector?(
        "title",
        text: "Right, off you go. - The Bridge of Death - GOV.UK",
        visible: :all,
      )

      assert page.has_selector?(
        "meta[name=robots][content=noindex]",
        visible: :all,
      )
    end

    within ".govuk-summary-list" do
      within ".govuk-summary-list__row:nth-child(1)" do
        within ".govuk-summary-list__key" do
          assert_page_has_content "1. What...is your name?"
        end
        within(".govuk-summary-list__value") { assert_page_has_content "Sir Lancelot of Camelot" }
        within(".govuk-summary-list__actions") { assert page.has_link?("Change", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
      end
      within ".govuk-summary-list__row:nth-child(2)" do
        within ".govuk-summary-list__key" do
          assert_page_has_content "2. What...is your favorite colour?"
        end
        within(".govuk-summary-list__value") { assert_page_has_content "Blue" }
        within(".govuk-summary-list__actions") { assert page.has_link?("Change", href: "/the-bridge-of-death/y/sir-lancelot-of-camelot?previous_response=blue") }
      end
    end

    within "[data-module='track-smart-answer ga4-auto-tracker']" do
      within("h1") { assert_page_has_content "Right, off you go." }
      assert_page_has_content "Oh! Well, thank you. Thank you very much."
    end
  end

  should "load the appropriate GA4 attributes at each step" do
    visit "/the-bridge-of-death"
    assert page.has_selector?("[data-ga4-link='{\"event_name\":\"form_start\",\"type\":\"simple smart answer\",\"section\":\"start page\",\"action\":\"start\",\"tool_name\":\"The Bridge of Death\"}']")

    click_on "Start now"
    assert_current_url "/the-bridge-of-death/y"
    assert page.has_no_selector?("[data-ga4-link='{\"event_name\":\"form_start\",\"type\":\"simple smart answer\",\"section\":\"start page\",\"action\":\"start\",\"tool_name\":\"The Bridge of Death\"}']")
    assert page.has_selector?("[data-module='ga4-form-tracker']")
    assert page.has_selector?("[data-ga4-form='{\"event_name\":\"form_response\",\"type\":\"simple smart answer\",\"section\":\"What...is your name?\",\"action\":\"Next step\",\"tool_name\":\"The Bridge of Death\"}']")

    choose "Sir Lancelot of Camelot"
    click_on "Next step"
    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot"
    assert page.has_no_selector?("[data-ga4-link='{\"event_name\":\"form_start\",\"type\":\"simple smart answer\",\"section\":\"start page\",\"action\":\"start\",\"tool_name\":\"The Bridge of Death\"}']")
    assert page.has_selector?("[data-module='ga4-form-tracker']")
    assert page.has_selector?("[data-ga4-form='{\"event_name\":\"form_response\",\"type\":\"simple smart answer\",\"section\":\"What...is your favorite colour?\",\"action\":\"Next step\",\"tool_name\":\"The Bridge of Death\"}']")
    assert page.has_selector?("[data-ga4-link='{\"event_name\":\"form_start_again\",\"type\":\"simple smart answer\",\"section\":\"What...is your favorite colour?\",\"action\":\"start again\",\"tool_name\":\"The Bridge of Death\"}']")
    assert page.has_selector?("[data-ga4-link='{\"event_name\":\"form_change_response\",\"type\":\"simple smart answer\",\"section\":\"What...is your name?\",\"action\":\"change response\",\"tool_name\":\"The Bridge of Death\"}']")
  end

  should "load the appropriate GA4 data attributes when there is an error" do
    visit "/the-bridge-of-death"

    click_on "Start now"
    assert_current_url "/the-bridge-of-death/y"

    click_on "Next step"
    assert page.has_selector?("[data-module='ga4-auto-tracker']")
    assert page.has_selector?("[data-ga4-auto='{\"event_name\":\"form_error\",\"type\":\"simple smart answer\",\"text\":\"Please answer this question\",\"section\":\"What...is your name?\",\"action\":\"error\",\"tool_name\":\"The Bridge of Death\"}']")
  end

  should "tell GA when we reach the end of the smart answer" do
    visit "/the-bridge-of-death"
    click_on "Start now"
    assert_current_url "/the-bridge-of-death/y"
    assert page.has_no_selector?("[data-module='track-smart-answer ga4-auto-tracker'][data-smart-answer-node-type=outcome]")

    choose "Sir Lancelot of Camelot"
    click_on "Next step"
    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot"
    assert page.has_no_selector?("[data-module='track-smart-answer ga4-auto-tracker'][data-smart-answer-node-type=outcome]")

    choose "Blue"
    click_on "Next step"

    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"
    # Asserting that we have the right data attribtues to trigger the
    # TrackSmartAnswer JavaScript module doesn't feel like enough, but it'll do.
    assert page.has_selector?("[data-module='track-smart-answer ga4-auto-tracker'][data-smart-answer-node-type=outcome]")
    assert page.has_selector?("[data-ga4-auto='{\"event_name\":\"form_complete\",\"type\":\"simple smart answer\",\"section\":\"Right, off you go.\",\"action\":\"complete\",\"tool_name\":\"The Bridge of Death\"}']")
    assert page.has_selector?("[data-ga4-link='{\"event_name\":\"information_click\",\"type\":\"simple smart answer\",\"section\":\"Right, off you go.\",\"action\":\"information_click\",\"tool_name\":\"The Bridge of Death\"}']")
    assert page.has_selector?("[data-ga4-link='{\"event_name\":\"form_start_again\",\"type\":\"simple smart answer\",\"section\":\"Right, off you go.\",\"action\":\"start again\",\"tool_name\":\"The Bridge of Death\"}']")
    assert page.has_selector?("[data-ga4-link='{\"event_name\":\"form_change_response\",\"type\":\"simple smart answer\",\"section\":\"What...is your name?\",\"action\":\"change response\",\"tool_name\":\"The Bridge of Death\"}']")
    assert page.has_selector?("[data-ga4-link='{\"event_name\":\"form_change_response\",\"type\":\"simple smart answer\",\"section\":\"What...is your favorite colour?\",\"action\":\"change response\",\"tool_name\":\"The Bridge of Death\"}']")
  end

  should "should add hidden token param when fact checking" do
    token = "5UP3R_53CR3T_F4CT_CH3CK_T0k3N"

    visit "/the-bridge-of-death?token=#{token}"

    click_on "Start now"

    assert_current_url "/the-bridge-of-death/y?token=#{token}"
    assert page.has_selector?("input[value='#{token}']", visible: false)
  end

  should "allow changing an answer" do
    visit "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"

    within ".govuk-summary-list .govuk-summary-list__row:nth-child(2)" do
      click_on "Change"
    end

    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot", ignore_query: true

    within ".govuk-summary-list" do
      assert page.has_selector?(".govuk-summary-list__row", count: 1)

      within ".govuk-summary-list__row" do
        within ".govuk-summary-list__key" do
          assert_page_has_content "1. What...is your name?"
        end
        within(".govuk-summary-list__value") { assert_page_has_content "Sir Lancelot of Camelot" }
        within(".govuk-summary-list__actions") { assert page.has_link?("Change", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
      end
    end

    within "#content .govuk-form-group" do
      within ".govuk-fieldset__legend" do
        assert_page_has_content "2. What...is your favorite colour?"
      end
      within ".govuk-radios" do
        assert page.has_field?("Blue", type: "radio", with: "blue", checked: true)
      end
    end

    choose "Blue... NO! YELLOOOOOOOOOOOOOOOOWWW!!!!"
    click_on "Next step"

    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue-no-yelloooooooooooooooowww"

    assert_page_has_content "AAAAARRRRRRRRRRRRRRRRGGGGGHHH!!!!!!!"
  end

  should "handle invalid responses in the url param correctly" do
    visit "/the-bridge-of-death/y/sir-lancelot-of-camelot/ultramarine"

    within ".govuk-summary-list" do
      assert page.has_selector?(".govuk-summary-list__row", count: 1)

      within ".govuk-summary-list__row" do
        within ".govuk-summary-list__key" do
          assert_page_has_content "1. What...is your name?"
        end
        within(".govuk-summary-list__value") { assert_page_has_content "Sir Lancelot of Camelot" }
        within(".govuk-summary-list__actions") { assert page.has_link?("Change", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
      end
    end

    within ".govuk-fieldset" do
      within ".govuk-fieldset__legend" do
        assert_page_has_content "What...is your favorite colour?"
      end
      assert page.has_selector?(".govuk-error-message", text: "Please answer this question")
    end

    choose "Blue"
    click_on "Next step"

    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"

    assert page.has_selector?(".govuk-summary-list .govuk-summary-list__row", count: 2)
    assert_page_has_content "Right, off you go"
  end

  should "handle empty form submissions correctly" do
    visit "/the-bridge-of-death/y/sir-lancelot-of-camelot"

    within "#content .govuk-form-group" do
      within ".govuk-fieldset__legend" do
        assert_page_has_content "2. What...is your favorite colour?"
      end
      assert_not page.has_selector?(".govuk-error-message", text: "Please answer this question")
    end

    click_on "Next step"

    within "#content .govuk-form-group" do
      within ".govuk-fieldset__legend" do
        assert_page_has_content "2. What...is your favorite colour?"
      end
      assert page.has_selector?(".govuk-error-message", text: "Please answer this question")
    end
  end

  should "handle invalid form submissions correctly" do
    visit "/the-bridge-of-death/y/sir-lancelot-of-camelot?response=ultramarine"

    within ".govuk-summary-list" do
      assert page.has_selector?(".govuk-summary-list__row", count: 1)

      within ".govuk-summary-list__row" do
        within ".govuk-summary-list__key" do
          assert_page_has_content "1. What...is your name?"
        end
        within(".govuk-summary-list__value") { assert_page_has_content "Sir Lancelot of Camelot" }
        within(".govuk-summary-list__actions") { assert page.has_link?("Change", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
      end
    end

    within "#content .govuk-form-group" do
      within ".govuk-fieldset__legend" do
        assert_page_has_content "2. What...is your favorite colour?"
      end
      assert page.has_selector?(".govuk-error-message", text: "Please answer this question")
    end

    choose "Blue"
    click_on "Next step"

    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"

    assert page.has_selector?(".govuk-summary-list .govuk-summary-list__row", count: 2)
    assert_page_has_content "Right, off you go"
  end

  should "handle invalid url params combined with form submissions correctly" do
    visit "/the-bridge-of-death/y/sir-lancelot-of-camelot/ultramarine?response=blue"

    within ".govuk-summary-list" do
      assert page.has_selector?(".govuk-summary-list__row", count: 1)

      within ".govuk-summary-list__row" do
        within ".govuk-summary-list__key" do
          assert_page_has_content "1. What...is your name?"
        end
        within(".govuk-summary-list__value") { assert_page_has_content "Sir Lancelot of Camelot" }
        within(".govuk-summary-list__actions") { assert page.has_link?("Change", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
      end
    end

    within "#content .govuk-form-group" do
      within ".govuk-fieldset__legend" do
        assert_page_has_content "2. What...is your favorite colour?"
      end
      assert page.has_selector?(".govuk-error-message", text: "Please answer this question")
    end

    choose "Blue"
    click_on "Next step"

    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"

    assert page.has_selector?(".govuk-summary-list .govuk-summary-list__row", count: 2)
    assert_page_has_content "Right, off you go"
  end
end
