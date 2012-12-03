# encoding: utf-8
require_relative '../integration_test_helper'

class TransactionRenderingTest < ActionDispatch::IntegrationTest

  context "a transaction with expectations but no 'before you start' and 'other ways to apply'" do
    should "render the main information" do
      setup_api_responses('register-to-vote')
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
          assert page.has_link?("Not what you're looking for? ↓", :href => "#related")
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

    should "render the welsh version correctly" do
      # Note, this is using an english piece of content set to Welsh
      # This is fine because we're testing the page furniture, not the rendering of the content.
      artefact = content_api_response('register-to-vote')
      artefact["details"]["language"] = "cy"
      content_api_has_an_artefact('register-to-vote', artefact)
      visit "/register-to-vote"

      assert_equal 200, page.status_code

      within '#content' do
        within 'header' do
          assert page.has_content?("Register to vote")
          assert page.has_content?("Gwasanaeth")
          assert page.has_link?("Ddim beth rydych chi'n chwilio amdano? ↓", :href => "#related")
        end

        within '.article-container' do
          within 'section.intro' do
            assert page.has_link?("Dechrau nawr", :href => "http://www.aboutmyvote.co.uk/")
            assert page.has_content?("ar the Electoral Commission website")
          end

          within 'section.more' do
            assert page.has_selector?('h1', :text => "Yr hyn mae angen i chi ei wybod")

            expectations = page.all('#what-you-need-to-know li').map(&:text)
            assert_equal ['Takes around 10 minutes (in Welsh)', 'Includes offline steps'], expectations
          end

          assert page.has_selector?(".modified-date", :text => "Diweddarwyd diwethaf: 22 Hydref 2012")
        end
      end # within #content
    end
  end

  context "a transaction with all 3 'more information' sections" do
    should "render tabs for more information" do
      setup_api_responses('apply-first-provisional-driving-licence')
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

    should "render the welsh version correctly" do
      # Note, this is using an english piece of content set to Welsh
      # This is fine because we're testing the page furniture, not the rendering of the content.
      artefact = content_api_response('apply-first-provisional-driving-licence')
      artefact["details"]["language"] = "cy"
      content_api_has_an_artefact('apply-first-provisional-driving-licence', artefact)
      visit "/apply-first-provisional-driving-licence"

      assert_equal 200, page.status_code

      within '#content .article-container section.more' do
        expected = ['Cyn i chi ddechrau', 'Yr hyn mae angen i chi ei wybod', 'Ffyrdd eraill o wneud cais']
        tabs = page.all('nav.nav-tabs li').map(&:text)
        assert_equal expected, tabs
      end
    end
  end

  context "Jobsearch special case" do

    should "render the jobsearch page correctly" do
      setup_api_responses('jobs-jobsearch')
      visit "/jobs-jobsearch"

      assert_equal 200, page.status_code

      within 'head' do
        assert page.has_selector?("title", :text => "Find a job with Universal Jobmatch - GOV.UK")
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/jobs-jobsearch.json']")
      end

      within '#content' do
        within 'header' do
          assert page.has_content?("Service")
          assert page.has_content?("Find a job with Universal Jobmatch")
        end

        within '.article-container' do
          within 'section.intro' do
            assert page.has_selector?(".application-notice p", :text => "You may have difficulties using this service while it’s being improved - if you’re affected, please try again later.")

            assert page.has_selector?("form.jobsearch-form[action='https://jobsearch.direct.gov.uk/JobSearch/PowerSearch.aspx'][method=get]")
            within "form.jobsearch-form" do
              assert page.has_field?("Job title", :type => "text")
              assert page.has_field?("Town, place or postcode", :type => "text")
              assert page.has_field?("Skills (optional)", :type => "text")

              assert page.has_selector?("button", :text => "Search")
              assert page.has_content?("on Universal Jobmatch")
            end
          end

          within 'section.more' do
            expected = ['Before you start', 'Other ways to apply']
            tabs = page.all('nav.nav-tabs li').map(&:text)
            assert_equal expected, tabs

            within '.tab-content' do
              within '#before-you-start' do
                assert page.has_selector?(".application-notice p", :text => "Universal Jobmatch has replaced the Jobcentre Plus job search tool.")
              end

              within '#other-ways-to-apply' do
                assert page.has_selector?('p', :text => "You can also search for jobs by calling Jobcentre Plus.")
              end
            end # within .tab_content
          end

          assert page.has_selector?(".modified-date", :text => "Last updated: 20 November 2012")

          assert page.has_selector?("#test-report_a_problem")
        end
      end # within #content

      assert page.has_selector?("#test-related")
    end

    should "render welsh jobsearch page correctly" do
      # Note, this is using the english versions, set to welsh
      # This is fine because we're testing the page furniture, not the rendering of the content.
      # We can use the welsh version when it exists.
      artefact = content_api_response('jobs-jobsearch')
      artefact["details"]["language"] = "cy"
      content_api_has_an_artefact('chwilio-am-swydd', artefact)

      visit "/chwilio-am-swydd"

      assert_equal 200, page.status_code

      within '#content' do
        within 'header' do
          assert page.has_content?("Gwasanaeth")
          assert page.has_content?("Find a job with Universal Jobmatch")
        end

        within '.article-container' do
          within 'section.intro' do
            within "form.jobsearch-form" do
              assert page.has_field?("Teitl swydd", :type => "text")
              assert page.has_field?("Tref, lle neu god post", :type => "text")
              assert page.has_field?("Sgiliau (dewisol)", :type => "text")

              assert page.has_selector?("button", :text => "Chwilio")
              assert page.has_content?("ar Universal Jobmatch")
            end
          end

          within 'section.more' do
            expected = ['Cyn i chi ddechrau', 'Ffyrdd eraill o wneud cais']
            tabs = page.all('nav.nav-tabs li').map(&:text)
            assert_equal expected, tabs
          end

          assert page.has_selector?(".modified-date", :text => "Diweddarwyd diwethaf: 20 Tachwedd 2012")
        end
      end # within #content
    end
  end
end
