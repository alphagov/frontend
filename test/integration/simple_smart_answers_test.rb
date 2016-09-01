# encoding: utf-8
require 'integration_test_helper'

class SimpleSmartAnswersTest < ActionDispatch::IntegrationTest

  setup do
    setup_api_responses('the-bridge-of-death')
  end

  should "render the start page correctly" do
    visit "/the-bridge-of-death"

    assert_equal 200, page.status_code

    within 'head', :visible => :all do
      assert page.has_selector?('title', :text => "The Bridge of Death - GOV.UK", :visible => :all)
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/the-bridge-of-death.json']", :visible => :all)
    end

    within '#global-breadcrumb' do
      assert_page_has_content "Bridges"
      assert_page_has_content "Fictional"
    end

    within '#content' do
      within 'header.page-header' do
        assert_page_has_content("The Bridge of Death")
      end

      within '.article-container' do
        within '.intro' do
          assert_page_has_content("He who would cross the Bridge of Death Must answer me These questions three Ere the other side he see.")
          assert page.has_link?("Start now", :href => "/the-bridge-of-death/y")
        end

        assert page.has_selector?(shared_component_selector('beta_label'))
        within(".modified-date") { assert_page_has_content "Last updated: 25 June 2013" }

      end
    end # within #content

    assert page.has_selector?("#test-related")
  end

  # This should be with_and_without_javascript when the AJAX variant is implemented
  without_javascript do
    should "handle the flow correctly" do
      visit "/the-bridge-of-death"

      click_on "Start now"

      assert_current_url "/the-bridge-of-death/y"

      within 'head', :visible => :all do
        assert page.has_selector?('title', :text => "The Bridge of Death - GOV.UK", :visible => :all)
        assert page.has_selector?("meta[name=robots][content=noindex]", :visible => :all)
      end

      within '#global-breadcrumb' do
        assert_page_has_content "Bridges"
        assert_page_has_content "Fictional"
      end

      within '#content' do
        within 'header.page-header' do
          assert_page_has_content("The Bridge of Death")
        end
      end

      within '.current-question' do
        within 'h2' do
          within('.question-number') { assert_page_has_content "1" }
          assert_page_has_content "What...is your name?"
        end
        assert_page_has_content "It's the old man from Scene 24!!"
        within '.question-body' do
          assert page.has_field?("Sir Lancelot of Camelot", :type => 'radio', :with => "sir-lancelot-of-camelot")
          assert page.has_field?("Sir Robin of Camelot", :type => 'radio', :with => "sir-robin-of-camelot")
          assert page.has_field?("Sir Galahad of Camelot", :type => 'radio', :with => "sir-galahad-of-camelot")
          # Assert they're in the correct order
          options = page.all(:xpath, ".//label").map(&:text).map(&:strip)
          assert_equal ["Sir Lancelot of Camelot", "Sir Robin of Camelot", "Sir Galahad of Camelot"], options
        end
      end

      choose "Sir Lancelot of Camelot"
      click_on "Next step"

      assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot"

      within '.done-questions' do
        within('.start-again') { assert page.has_link?("Start again", :href => '/the-bridge-of-death') }
        within 'ol li.done' do
          within 'h3' do
            within('.question-number') { assert_page_has_content "1" }
            assert_page_has_content "What...is your name?"
          end
          within('.answer') { assert_page_has_content "Sir Lancelot of Camelot" }
          within('.undo') { assert page.has_link?("Change this answer", :href => "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
        end
      end

      within '.current-question' do
        within 'h2' do
          within('.question-number') { assert_page_has_content "2" }
          assert_page_has_content "What...is your favorite colour?"
        end
        within '.question-body' do
          assert page.has_field?("Blue", :type => 'radio', :with => "blue")
          assert page.has_field?("Blue... NO! YELLOOOOOOOOOOOOOOOOWWW!!!!", :type => 'radio', :with => "blue-no-yelloooooooooooooooowww")
          # Assert they're in the correct order
          options = page.all(:xpath, ".//label").map(&:text).map(&:strip)
          assert_equal ["Blue", "Blue... NO! YELLOOOOOOOOOOOOOOOOWWW!!!!"], options
        end
      end

      choose "Blue"
      click_on "Next step"

      assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"

      within '.done-questions' do
        within('.start-again') { assert page.has_link?("Start again", :href => '/the-bridge-of-death') }
        within 'ol li.done:nth-child(1)' do
          within 'h3' do
            within('.question-number') { assert_page_has_content "1" }
            assert_page_has_content "What...is your name?"
          end
          within('.answer') { assert_page_has_content "Sir Lancelot of Camelot" }
          within('.undo') { assert page.has_link?("Change this answer", :href => "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
        end
        within 'ol li.done:nth-child(2)' do
          within 'h3' do
            within('.question-number') { assert_page_has_content "2" }
            assert_page_has_content "What...is your favorite colour?"
          end
          within('.answer') { assert_page_has_content "Blue" }
          within('.undo') { assert page.has_link?("Change this answer", :href => "/the-bridge-of-death/y/sir-lancelot-of-camelot?previous_response=blue") }
        end
      end

      within '.outcome' do
        within '.result-info' do
          within('h2.result-title') { assert_page_has_content "Right, off you go." }
          assert_page_has_content "Oh! Well, thank you. Thank you very much."
        end
      end
    end

    should "allow changing an answer" do
      visit "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"

      within '.done-questions ol li.done:nth-child(2)' do
        click_on "Change this answer"
      end

      assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot", :ignore_query => true

      within '.done-questions' do
        assert page.has_selector?('li.done', :count => 1)

        within 'ol li.done' do
          within 'h3' do
            within('.question-number') { assert_page_has_content "1" }
            assert_page_has_content "What...is your name?"
          end
          within('.answer') { assert_page_has_content "Sir Lancelot of Camelot" }
          within('.undo') { assert page.has_link?("Change this answer", :href => "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
        end
      end

      within '.current-question' do
        within 'h2' do
          within('.question-number') { assert_page_has_content "2" }
          assert_page_has_content "What...is your favorite colour?"
        end
        within '.question-body' do
          assert page.has_field?("Blue", :type => 'radio', :with => "blue", :checked => true)
        end
      end

      choose "Blue... NO! YELLOOOOOOOOOOOOOOOOWWW!!!!"
      click_on "Next step"

      assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue-no-yelloooooooooooooooowww"


      assert_page_has_content "AAAAARRRRRRRRRRRRRRRRGGGGGHHH!!!!!!!"
    end

    should "handle invalid responses in the url param correctly" do
      visit "/the-bridge-of-death/y/sir-lancelot-of-camelot/ultramarine"

      within '.done-questions' do
        assert page.has_selector?('li.done', :count => 1)

        within 'ol li.done' do
          within 'h3' do
            within('.question-number') { assert_page_has_content "1" }
            assert_page_has_content "What...is your name?"
          end
          within('.answer') { assert_page_has_content "Sir Lancelot of Camelot" }
          within('.undo') { assert page.has_link?("Change this answer", :href => "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
        end
      end

      within '.current-question' do
        within 'h2' do
          assert_page_has_content "What...is your favorite colour?"
        end
        within '.question-body' do
          assert page.has_selector?(".error-message", :text => "Please answer this question")
        end
      end

      choose "Blue"
      click_on "Next step"

      assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"

      assert page.has_selector?('.done-questions li.done', :count => 2)
      assert_page_has_content "Right, off you go"
    end

    should "handle invalid form submissions correctly" do
      visit "/the-bridge-of-death/y/sir-lancelot-of-camelot?response=ultramarine"

      within '.done-questions' do
        assert page.has_selector?('li.done', :count => 1)

        within 'ol li.done' do
          within 'h3' do
            within('.question-number') { assert_page_has_content "1" }
            assert_page_has_content "What...is your name?"
          end
          within('.answer') { assert_page_has_content "Sir Lancelot of Camelot" }
          within('.undo') { assert page.has_link?("Change this answer", :href => "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
        end
      end

      within '.current-question' do
        within 'h2' do
          within('.question-number') { assert_page_has_content "2" }
          assert_page_has_content "What...is your favorite colour?"
        end
        within '.question-body' do
          assert page.has_selector?(".error-message", :text => "Please answer this question")
        end
      end

      choose "Blue"
      click_on "Next step"

      assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"

      assert page.has_selector?('.done-questions li.done', :count => 2)
      assert_page_has_content "Right, off you go"

    end

    should "handle invalid url params combined with form submissions correctly" do
      visit "/the-bridge-of-death/y/sir-lancelot-of-camelot/ultramarine?response=blue"

      within '.done-questions' do
        assert page.has_selector?('li.done', :count => 1)

        within 'ol li.done' do
          within 'h3' do
            within('.question-number') { assert_page_has_content "1" }
            assert_page_has_content "What...is your name?"
          end
          within('.answer') { assert_page_has_content "Sir Lancelot of Camelot" }
          within('.undo') { assert page.has_link?("Change this answer", :href => "/the-bridge-of-death/y?previous_response=sir-lancelot-of-camelot") }
        end
      end

      within '.current-question' do
        within 'h2' do
          within('.question-number') { assert_page_has_content "2" }
          assert_page_has_content "What...is your favorite colour?"
        end
        within '.question-body' do
          assert page.has_selector?(".error-message", :text => "Please answer this question")
        end
      end

      choose "Blue"
      click_on "Next step"

      assert_current_url "/the-bridge-of-death/y/sir-lancelot-of-camelot/blue"

      assert page.has_selector?('.done-questions li.done', :count => 2)
      assert_page_has_content "Right, off you go"

    end
  end # without javascript

  # Capybara with rack-test behaves differently to real browsers when handling method=get
  # forms with get params in the action URL.  Real browsers remove the get params, and replace them
  # with the form values.  Capybara merges them together, causing this test to give a false positive.
  #
  # Poltergeist does the right thing.
  with_javascript do
    should "allow previewing a draft version" do
      content_api_has_a_draft_artefact "the-bridge-of-death", 2, content_api_response("the-bridge-of-death-draft")

      visit "/the-bridge-of-death?edition=2"

      click_on "Click here"

      assert_current_url "/the-bridge-of-death/y?edition=2"

      within '#content' do
        within 'header.page-header' do
          assert_page_has_content("The Bridge of Death")
        end
      end

      within '.current-question' do
        within 'h2' do
          within('.question-number') { assert_page_has_content "1" }
          assert_page_has_content "What...is your name?"
        end
        assert_page_has_content "It's the old man from Scene 24!!"
        within '.question-body' do
          assert page.has_field?("Sir Lancelot of Camelot", :type => 'radio', :with => "sir-lancelot-of-camelot")
          assert page.has_field?("Sir Robin of Camelot", :type => 'radio', :with => "sir-robin-of-camelot")
          assert page.has_field?("Sir Galahad of Camelot", :type => 'radio', :with => "sir-galahad-of-camelot")
          assert page.has_field?("King Arthur of the Britons!", :type => 'radio', :with => "king-arthur-of-the-britons")
          # Assert they're in the correct order
          options = page.all(:xpath, ".//label").map(&:text).map(&:strip)
          assert_equal ["Sir Lancelot of Camelot", "Sir Robin of Camelot", "Sir Galahad of Camelot", "King Arthur of the Britons!"], options
        end

        # Ensure the edition param isn't added to the form URL as it needs to be in a hidden field.
        assert_match %r(/the-bridge-of-death/y$), page.find('form')["action"]
      end

      choose "King Arthur of the Britons!"
      click_on "Next step"

      assert_current_url "/the-bridge-of-death/y/king-arthur-of-the-britons?edition=2"

      within '.done-questions' do
        within('.start-again') { assert page.has_link?("Start again", :href => '/the-bridge-of-death?edition=2') }
        within 'ol li.done' do
          within 'h3' do
            within('.question-number') { assert_page_has_content "1" }
            assert_page_has_content "What...is your name?"
          end
          within('.answer') { assert_page_has_content "King Arthur of the Britons!" }
          within('.undo') { assert page.has_link?("Change this answer", :href => "/the-bridge-of-death/y?edition=2&previous_response=king-arthur-of-the-britons") }
        end
      end

      within '.current-question' do
        within 'h2' do
          within('.question-number') { assert_page_has_content "2" }
          assert_page_has_content "What...is your favorite colour?"
        end
        within '.question-body' do
          assert page.has_field?("Blue", :type => 'radio', :with => "blue")
          assert page.has_field?("Blue... NO! YELLOOOOOOOOOOOOOOOOWWW!!!!", :type => 'radio', :with => "blue-no-yelloooooooooooooooowww")
          # Assert they're in the correct order
          options = page.all(:xpath, ".//label").map(&:text).map(&:strip)
          assert_equal ["Blue", "Blue... NO! YELLOOOOOOOOOOOOOOOOWWW!!!!"], options
        end
      end

      choose "Blue"
      click_on "Next step"

      assert_current_url "/the-bridge-of-death/y/king-arthur-of-the-britons/blue?edition=2"

      within '.done-questions' do
        within('.start-again') { assert page.has_link?("Start again", :href => '/the-bridge-of-death?edition=2') }
        within 'ol li.done:nth-child(1)' do
          within 'h3' do
            within('.question-number') { assert_page_has_content "1" }
            assert_page_has_content "What...is your name?"
          end
          within('.answer') { assert_page_has_content "King Arthur of the Britons!" }
          within('.undo') { assert page.has_link?("Change this answer", :href => "/the-bridge-of-death/y?edition=2&previous_response=king-arthur-of-the-britons") }
        end
        within 'ol li.done:nth-child(2)' do
          within 'h3' do
            within('.question-number') { assert_page_has_content "2" }
            assert_page_has_content "What...is your favorite colour?"
          end
          within('.answer') { assert_page_has_content "Blue" }
          within('.undo') { assert page.has_link?("Change this answer", :href => "/the-bridge-of-death/y/king-arthur-of-the-britons?edition=2&previous_response=blue") }
        end
      end

      within '.outcome' do
        within '.result-info' do
          within('h2.result-title') { assert_page_has_content "Right, off you go." }
          assert_page_has_content "Oh! Well, thank you. Thank you very much."
        end
      end
    end
  end # with javascript
end
