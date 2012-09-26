require_relative '../integration_test_helper'

class TransactionRenderingTest < ActionDispatch::IntegrationTest

  context "a transaction with expectations but no 'before you start' and 'other ways to apply'" do
    setup do
      setup_api_responses('register-to-vote')
    end

    should "render the main information" do
      visit "/register-to-vote"

      within 'section#content' do

        within('header h1') { assert page.has_content?("Register to vote") }

        within 'section.intro' do
          assert page.has_content?("You have to fill out the form online, print it off and send it to your local electoral registration office.")

          assert page.has_link?("Start now on the Electoral Commission website", :href => "http://www.aboutmyvote.co.uk/")
        end

        within 'section.more' do
          assert page.has_no_selector?('nav.nav-tabs')

          assert page.has_selector?('h1', :text => "What you need to know")

          expectations = page.all('#what-you-need-to-know li').map(&:text)
          assert_equal ['Takes around 10 minutes', 'Includes offline steps'], expectations
        end

        assert page.has_selector?(".article-container #test-report_a_problem")
      end
    end
  end

  context "a transaction with all 3 'more information' sections" do
    setup do
      setup_api_responses('apply-first-provisional-driving-licence')
    end

    should "render tabs for more information" do
      visit "/apply-first-provisional-driving-licence"

      within 'section#content section.more' do
        expected = ['Before you start', 'What you need to know', 'Other ways to apply']
        tabs = page.all('nav.nav-tabs li').map(&:text)
        assert_equal expected, tabs

        within '.tab-content' do
          within '#before-you-start' do
            assert page.has_no_selector?('h1')

            assert page.has_content?("Driving licence more information")
            assert page.has_no_content?("------") # Markdown should be rendered, not output
          end

          within '#what-you-need-to-know' do
            assert page.has_no_selector?('h1')

            expectations = page.all('li').map(&:text)
            assert_equal ['Proof of identification required', 'National Insurance number required', 'Debit or credit card required'], expectations
          end

          within '#other-ways-to-apply' do
            assert page.has_no_selector?('h1')

            assert page.has_content?("Driving licence alternate methods")
            assert page.has_no_content?("------") # Markdown should be rendered, not output
          end

        end # .tab-content
      end
    end
  end

end
