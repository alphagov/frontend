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
      assert page.has_selector?("title", text: "The Bridge of Death - GOV.UK", visible: :all)
    end

    within "#content" do
      within "header.page-header" do
        assert_has_component_title "The Bridge of Death"
      end

      within ".article-container" do
        within ".intro" do
          assert_page_has_content("He who would cross the Bridge of Death Must answer me These questions three Ere the other side he see.")
          assert_has_button_as_link("Start now",
                                    href: "/the-bridge-of-death/y",
                                    start: true,
                                    rel: "nofollow")
        end

        assert page.has_selector?(".gem-c-phase-banner")
      end
    end
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
      assert page.has_selector?("title", text: "The Bridge of Death - GOV.UK", visible: :all)
      assert page.has_selector?("meta[name=robots][content=noindex]", visible: :all)
    end

    within "#content" do
      within "header.page-header" do
        assert_page_has_content("The Bridge of Death")
      end
    end

    within ".current-question" do
      within "h2" do
        within(".question-number") { assert_page_has_content "1" }
        assert_page_has_content "What...is your name?"
      end
      assert_page_has_content "It's the old man from Scene 24!!"
      within ".question-body" do
        assert page.has_field?("Sir Lancelot of Camelot", type: "radio", with: "sir-lancelot-of-camelot")
        assert page.has_field?("Sir Robin of Camelot", type: "radio", with: "sir-robin-of-camelot")
        assert page.has_field?("Sir Galahad of Camelot", type: "radio", with: "sir-galahad-of-camelot")
        # Assert they're in the correct order
        options = page.all(:xpath, ".//label").map(&:text).map(&:strip)
        assert_equal ["Sir Lancelot of Camelot", "Sir Robin of Camelot", "Sir Galahad of Camelot"], options
      end
    end

    choose "Sir Lancelot of Camelot"
    click_on "Next step"

    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot"

    within ".done-questions" do
      within(".start-again") { assert page.has_link?("Start again", href: "/the-bridge-of-death") }
      within "ol li.done" do
        within "h3" do
          within(".question-number") { assert_page_has_content "1" }
          assert_page_has_content "What...is your name?"
        end
        within(".answer") { assert_page_has_content "Sir Lancelot of Camelot" }
        within(".undo") { assert page.has_link?("Change this answer", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
      end
    end

    within ".current-question" do
      within "h2" do
        within(".question-number") { assert_page_has_content "2" }
        assert_page_has_content "What...is your favorite colour?"
      end
      within ".question-body" do
        assert page.has_field?("Blue", type: "radio", with: "blue")
        assert page.has_field?("Blue... NO! YELLOOOOOOOOOOOOOOOOWWW!!!!", type: "radio", with: "blue-no-yelloooooooooooooooowww")
        # Assert they're in the correct order
        options = page.all(:xpath, ".//label").map(&:text).map(&:strip)
        assert_equal ["Blue", "Blue... NO! YELLOOOOOOOOOOOOOOOOWWW!!!!"], options
      end
    end

    choose "Blue"
    click_on "Next step"

    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"

    within ".done-questions" do
      within(".start-again") { assert page.has_link?("Start again", href: "/the-bridge-of-death") }
      within "ol li.done:nth-child(1)" do
        within "h3" do
          within(".question-number") { assert_page_has_content "1" }
          assert_page_has_content "What...is your name?"
        end
        within(".answer") { assert_page_has_content "Sir Lancelot of Camelot" }
        within(".undo") { assert page.has_link?("Change this answer", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
      end
      within "ol li.done:nth-child(2)" do
        within "h3" do
          within(".question-number") { assert_page_has_content "2" }
          assert_page_has_content "What...is your favorite colour?"
        end
        within(".answer") { assert_page_has_content "Blue" }
        within(".undo") { assert page.has_link?("Change this answer", href: "/the-bridge-of-death/y/sir-lancelot-of-camelot?previous_response=blue") }
      end
    end

    within ".outcome" do
      within ".result-info" do
        within("h2.result-title") { assert_page_has_content "Right, off you go." }
        assert_page_has_content "Oh! Well, thank you. Thank you very much."
      end
    end
  end

  should "tell GA when we reach the end of the smart answer" do
    visit "/the-bridge-of-death"
    click_on "Start now"
    assert_current_url "/the-bridge-of-death/y"
    assert page.has_no_selector?("[data-module=track-smart-answer][data-smart-answer-node-type=outcome]")

    choose "Sir Lancelot of Camelot"
    click_on "Next step"
    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot"
    assert page.has_no_selector?("[data-module=track-smart-answer][data-smart-answer-node-type=outcome]")

    choose "Blue"
    click_on "Next step"

    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"
    # asserting that we have the right data attribtues to trigger the
    # TrackSmartAnswer JS module doesn't feel like enough, but it'll do
    assert page.has_selector?("[data-module=track-smart-answer][data-smart-answer-node-type=outcome]")
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

    within ".done-questions ol li.done:nth-child(2)" do
      click_on "Change this answer"
    end

    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot", ignore_query: true

    within ".done-questions" do
      assert page.has_selector?("li.done", count: 1)

      within "ol li.done" do
        within "h3" do
          within(".question-number") { assert_page_has_content "1" }
          assert_page_has_content "What...is your name?"
        end
        within(".answer") { assert_page_has_content "Sir Lancelot of Camelot" }
        within(".undo") { assert page.has_link?("Change this answer", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
      end
    end

    within ".current-question" do
      within "h2" do
        within(".question-number") { assert_page_has_content "2" }
        assert_page_has_content "What...is your favorite colour?"
      end
      within ".question-body" do
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

    within ".done-questions" do
      assert page.has_selector?("li.done", count: 1)

      within "ol li.done" do
        within "h3" do
          within(".question-number") { assert_page_has_content "1" }
          assert_page_has_content "What...is your name?"
        end
        within(".answer") { assert_page_has_content "Sir Lancelot of Camelot" }
        within(".undo") { assert page.has_link?("Change this answer", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
      end
    end

    within ".current-question" do
      within "h2" do
        assert_page_has_content "What...is your favorite colour?"
      end
      within ".question-body" do
        assert page.has_selector?(".error-message", text: "Please answer this question")
      end
    end

    choose "Blue"
    click_on "Next step"

    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"

    assert page.has_selector?(".done-questions li.done", count: 2)
    assert_page_has_content "Right, off you go"
  end

  should "handle empty form submissions correctly" do
    visit "/the-bridge-of-death/y/sir-lancelot-of-camelot"

    within ".current-question" do
      within "h2" do
        within(".question-number") { assert_page_has_content "2" }
        assert_page_has_content "What...is your favorite colour?"
      end
      within ".question-body" do
        assert_not page.has_selector?(".error-message", text: "Please answer this question")
      end
    end

    click_on "Next step"

    within ".current-question" do
      within "h2" do
        within(".question-number") { assert_page_has_content "2" }
        assert_page_has_content "What...is your favorite colour?"
      end
      within ".question-body" do
        assert page.has_selector?(".error-message", text: "Please answer this question")
      end
    end
  end

  should "handle invalid form submissions correctly" do
    visit "/the-bridge-of-death/y/sir-lancelot-of-camelot?response=ultramarine"

    within ".done-questions" do
      assert page.has_selector?("li.done", count: 1)

      within "ol li.done" do
        within "h3" do
          within(".question-number") { assert_page_has_content "1" }
          assert_page_has_content "What...is your name?"
        end
        within(".answer") { assert_page_has_content "Sir Lancelot of Camelot" }
        within(".undo") { assert page.has_link?("Change this answer", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
      end
    end

    within ".current-question" do
      within "h2" do
        within(".question-number") { assert_page_has_content "2" }
        assert_page_has_content "What...is your favorite colour?"
      end
      within ".question-body" do
        assert page.has_selector?(".error-message", text: "Please answer this question")
      end
    end

    choose "Blue"
    click_on "Next step"

    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"

    assert page.has_selector?(".done-questions li.done", count: 2)
    assert_page_has_content "Right, off you go"
  end

  should "handle invalid url params combined with form submissions correctly" do
    visit "/the-bridge-of-death/y/sir-lancelot-of-camelot/ultramarine?response=blue"

    within ".done-questions" do
      assert page.has_selector?("li.done", count: 1)

      within "ol li.done" do
        within "h3" do
          within(".question-number") { assert_page_has_content "1" }
          assert_page_has_content "What...is your name?"
        end
        within(".answer") { assert_page_has_content "Sir Lancelot of Camelot" }
        within(".undo") { assert page.has_link?("Change this answer", href: "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
      end
    end

    within ".current-question" do
      within "h2" do
        within(".question-number") { assert_page_has_content "2" }
        assert_page_has_content "What...is your favorite colour?"
      end
      within ".question-body" do
        assert page.has_selector?(".error-message", text: "Please answer this question")
      end
    end

    choose "Blue"
    click_on "Next step"

    assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"

    assert page.has_selector?(".done-questions li.done", count: 2)
    assert_page_has_content "Right, off you go"
  end
end
