require_relative '../integration_test_helper'

class TransactionRenderingTest < ActionDispatch::IntegrationTest

  context "a transaction with expectations but no 'before you start' and 'other ways to apply'" do
    setup do
      setup_api_responses('register-to-vote')
    end

    should "render the main information" do
      visit "/register-to-vote"

      assert_equal 200, page.status_code

      within 'head' do
        assert page.has_selector?("title", :text => "Register to vote - GOV.UK")
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/register-to-vote.json']")
      end

      within '#content' do
        within 'header' do
          assert page.has_content?("Register to vote")
          assert page.has_content?("Service")
        end

        within '.article-container' do
          within 'section.intro' do
            assert page.has_selector?("p", :text => "You have to fill out the form online, print it off and send it to your local electoral registration office.")

            assert page.has_link?("Start now", :href => "http://www.aboutmyvote.co.uk/")
            assert page.has_content?("on the Electoral Commission website")
          end

          within 'section.more' do
            assert page.has_no_selector?('nav.nav-tabs')

            assert page.has_selector?('h1', :text => "What you need to know")

            expectations = page.all('#what-you-need-to-know li').map(&:text)
            assert_equal ['Takes around 10 minutes', 'Includes offline steps'], expectations
          end

          assert page.has_selector?(".modified-date", :text => "Last updated: 22 October 2012")

          assert page.has_selector?("#test-report_a_problem")
        end
      end # within #content

      assert page.has_selector?("#test-related")
    end
  end

  context "a transaction with all 3 'more information' sections" do
    setup do
      setup_api_responses('apply-first-provisional-driving-licence')
    end

    should "render tabs for more information" do
      visit "/apply-first-provisional-driving-licence"

      assert_equal 200, page.status_code

      within 'head' do
        assert page.has_selector?("title", :text => "Apply for your first provisional driving licence - GOV.UK")
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/apply-first-provisional-driving-licence.json']")
      end

      within '#content .article-container section.more' do
        expected = ['Before you start', 'What you need to know', 'Other ways to apply']
        tabs = page.all('nav.nav-tabs li').map(&:text)
        assert_equal expected, tabs

        within '.tab-content' do
          within '#before-you-start' do
            assert page.has_no_selector?('h1')

            assert page.has_selector?("li", :text => "be a resident of Great Britain")
          end

          within '#what-you-need-to-know' do
            assert page.has_no_selector?('h1')

            expectations = page.all('li').map(&:text)
            assert_equal ['Proof of identification required', '3 years of address details required', 'Debit or credit card required'], expectations
          end

          within '#other-ways-to-apply' do
            assert page.has_no_selector?('h1')

            assert page.has_selector?('li', :text => "original documentation confirming your identity")
          end
        end # .tab-content
      end
    end
  end

end
