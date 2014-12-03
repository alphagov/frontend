# encoding: utf-8
require_relative '../integration_test_helper'

class TransactionRenderingTest < ActionDispatch::IntegrationTest

  context "a transaction with need_to_know but no 'before you start' and 'other ways to apply'" do
    should "render the main information" do
      setup_api_responses('register-to-vote')
      visit "/register-to-vote"

      assert_equal 200, page.status_code

      within 'head', :visible => :all do
        assert page.has_selector?("title", :text => "Register to vote - GOV.UK", :visible => :all)
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/register-to-vote.json']", :visible => :all)
      end

      within '#content' do
        within 'header' do
          assert page.has_content?("Register to vote")
        end

        within '.article-container' do
          within '.beta-label' do
            assert page.has_link?("find out what this means", :href => "/help/beta")
          end

          within 'section.intro' do
            assert page.has_selector?("p", :text => "You have to fill out the form online, print it off and send it to your local electoral registration office.")

            start_link = find_link("Start now")
            assert_equal "http://www.aboutmyvote.co.uk/", start_link["href"]
            assert_equal "register-to-vote", start_link["data-transaction-slug"]

            assert page.has_content?("on the Electoral Commission website")
          end

          within 'section.more' do
            assert page.has_no_selector?('div.nav-tabs')

            assert page.has_selector?('h1', :text => "What you need to know")

            need_to_know = page.all('#what-you-need-to-know li').map(&:text)
            assert_equal ['Takes around 10 minutes', 'Includes offline steps'], need_to_know
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
        end

        within '.article-container' do
          within 'section.intro' do
            assert page.has_link?("Dechrau nawr", :href => "http://www.aboutmyvote.co.uk/")
            assert page.has_content?("ar the Electoral Commission website")
          end

          within 'section.more' do
            assert page.has_selector?('h1', :text => "Yr hyn mae angen i chi ei wybod")

            need_to_know = page.all('#what-you-need-to-know li').map(&:text)
            assert_equal ["Mae’n cymryd tua 10 munud", 'Includes offline steps'], need_to_know
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

      within 'head', :visible => :all do
        assert page.has_selector?("title", :text => "Apply for your first provisional driving licence - GOV.UK", :visible => :all)
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/apply-first-provisional-driving-licence.json']", :visible => :all)
      end

      within '#content .article-container section.more' do
        expected = ['Before you start', 'What you need to know', 'Other ways to apply']
        tabs = page.all('div.nav-tabs li').map(&:text)
        assert_equal expected, tabs

        within '.tab-content' do
          within '#before-you-start' do
            assert page.has_no_selector?('h1')

            assert page.has_selector?("li", :text => "be a resident of Great Britain")
          end

          within '#what-you-need-to-know' do
            assert page.has_no_selector?('h1')

            need_to_know = page.all('li').map(&:text)
            assert_equal ['Proof of identification required', '3 years of address details required', 'Debit or credit card required'], need_to_know
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
        tabs = page.all('div.nav-tabs li').map(&:text)
        assert_equal expected, tabs
      end
    end
  end

  context "a transaction which should open in a new window" do
    should "have the correct target attribute set on the 'Start now' link for a new window" do
      setup_api_responses('find-your-local-council')
      visit '/find-your-local-council'

      assert_equal 200, page.status_code

      within '.article-container' do
        within 'section.intro' do
          assert page.has_selector?("a[href='http://local.direct.gov.uk/LDGRedirect/Start.do?mode=1'][target='_blank']", :text => "Start now")
        end
      end
    end
  end

  context "legacy transaction finished pages' special cases" do
    should "redirect transaction-finished JSON requests" do
      setup_api_responses('transaction-finished')
      get "/transaction-finished.json"
      assert_equal 301, response.code.to_i
      assert_redirected_to "/api/transaction-finished.json"
    end

    should "redirect driving-transaction-finished JSON requests" do
      setup_api_responses('driving-transaction-finished')
      get "/driving-transaction-finished.json"
      assert_equal 301, response.code.to_i
      assert_redirected_to "/api/driving-transaction-finished.json"
    end

    should "render the transaction-finished page correctly" do
      setup_api_responses('transaction-finished')
      visit "/transaction-finished"
      assert_equal 200, page.status_code
      within "#content" do
        within "header" do
          assert page.has_content?("Your transaction is finished")
        end
        within '.article-container' do
          assert page.has_content?("Please join the NHS Organ Donor Register")
          assert page.has_selector?(".button", :text => "Join")
        end
      end
    end

    should "render the driving-transaction-finished page correctly" do
      setup_api_responses('driving-transaction-finished')
      visit "driving-transaction-finished"
      assert_equal 200, page.status_code
      within "#content" do
        within "header" do
          assert page.has_content?("Thank you")
        end
      end
    end
  end

  context "Jobsearch special case" do

    should "redirect JSON requests to the correct API URL" do
      setup_api_responses('jobsearch')
      get "/jobsearch.json"
      assert_equal 301, response.code.to_i
      assert_redirected_to "/api/jobsearch.json"
    end

    should "render the jobsearch page correctly" do
      setup_api_responses('jobsearch')
      visit "/jobsearch"

      assert_equal 200, page.status_code

      within 'head', :visible => :all do
        assert page.has_selector?("title", :text => "Find a job with Universal Jobmatch - GOV.UK", :visible => :all)
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/jobsearch.json']", :visible => :all)
      end

      within '#content' do
        within 'header' do
          assert page.has_content?("Find a job with Universal Jobmatch")
        end

        within '.article-container' do
          within 'section.intro' do
            assert page.has_selector?(".application-notice p", :text => "You may have difficulties using this service while it’s being improved - if you’re affected, please try again later.")

            assert page.has_selector?("form.jobsearch-form[action='https://jobsearch.direct.gov.uk/JobSearch/PowerSearch.aspx'][method=get]")
            within "form.jobsearch-form" do
              assert page.has_field?("Job title", :type => "text")
              assert page.has_field?("Postcode, town or place", :type => "text")
              assert page.has_field?("Skills (optional)", :type => "text")

              assert page.has_selector?("button", :text => "Search")
              assert page.has_content?("on Universal Jobmatch")
            end
          end

          within 'section.more' do
            expected = ['Before you start', 'Other ways to apply']
            tabs = page.all('div.nav-tabs li').map(&:text)
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
      artefact = content_api_response('jobsearch')
      artefact["details"]["language"] = "cy"
      content_api_has_an_artefact('chwilio-am-swydd', artefact)

      visit "/chwilio-am-swydd"

      assert_equal 200, page.status_code

      within '#content' do
        within 'header' do
          assert page.has_content?("Find a job with Universal Jobmatch")
        end

        within '.article-container' do
          within 'section.intro' do
            assert page.has_selector?("form.jobsearch-form[action='https://jobsearch.direct.gov.uk/JobSearch/PowerSearch.aspx'][method=get]")
            within "form.jobsearch-form" do
              assert page.has_field?("Teitl swydd", :type => "text")
              assert page.has_field?("Cod post, Tref neu lle", :type => "text")
              assert page.has_field?("Sgiliau (dewisol)", :type => "text")

              assert page.has_selector?("button", :text => "Chwilio")
              assert page.has_content?("ar Universal Jobmatch")
            end
          end

          within 'section.more' do
            expected = ['Cyn i chi ddechrau', 'Ffyrdd eraill o wneud cais']
            tabs = page.all('div.nav-tabs li').map(&:text)
            assert_equal expected, tabs
          end

          assert page.has_selector?(".modified-date", :text => "Diweddarwyd diwethaf: 20 Tachwedd 2012")
        end
      end # within #content
    end
  end
  context "exceptional tax-disc start page format" do
    should "render a bespoke view" do
      setup_api_responses('tax-disc')
      visit "/tax-disc"
      assert_equal 200, page.status_code
      within("div.title h1") do
        assert page.has_content?("Renew a tax disc")
      end
      within(".primary-apply") do
        assert page.has_content?("Apply using the new service")
      end
    end
  end
  context "exceptional view-driving-licence start page format" do
    should "render a bespoke view" do
      setup_api_responses('view-driving-licence')
      visit "/view-driving-licence"
      assert_equal 200, page.status_code
      within("div.title h1") do
        assert page.has_content?("View your driving licence information")
      end
      within(".primary-apply") do
        assert page.has_content?("You'll need")
      end
    end
  end
  context "exceptional check-vehicle-tax start page format" do
    should "render a bespoke view" do
      setup_api_responses('check-vehicle-tax')
      visit "/check-vehicle-tax"
      assert_equal 200, page.status_code
      within("div.title h1") do
        assert page.has_content?("Check if a vehicle is taxed")
      end
      within(".primary-apply") do
        assert page.has_content?("Check using the new service")
      end
      within(".secondary-apply") do
        assert page.has_content?("Check using the original service")
      end
    end
  end

  context "start page which should have cross domain analytics" do
    should "include cross domain analytics javascript" do
      setup_api_responses('register-to-vote')
      visit "/register-to-vote"

      assert_equal 200, page.status_code
      assert page.has_selector?("#transaction_cross_domain_analytics", :visible => :all)
    end
  end

  context "start page format which shouldn't have cross domain analytics" do
    should "not include cross domain analytics javascript" do
      setup_api_responses('check-vehicle-tax')
      visit "/check-vehicle-tax"

      assert_equal 200, page.status_code
      assert page.has_no_selector?("#transaction_cross_domain_analytics", :visible => :all)
    end
  end
end
