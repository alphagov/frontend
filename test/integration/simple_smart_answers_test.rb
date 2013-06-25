# encoding: utf-8
require_relative '../integration_test_helper'

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

    within '#content' do
      within 'header.page-header' do
        assert_page_has_content("The Bridge of Death")
        assert_page_has_content("Quick answer")
        assert page.has_link?("Not what you're looking for? ↓", :href => "#related")
      end

      within '.article-container' do
        within '.intro' do
          assert_page_has_content("He who would cross the Bridge of Death Must answer me These questions three Ere the other side he see.")

          assert page.has_link?("Start now", :href => "/the-bridge-of-death/y")
        end

        within(".modified-date") { assert_page_has_content "Last updated: 25 June 2013" }

        assert page.has_selector?("#test-report_a_problem")
      end
    end # within #content

    assert page.has_selector?("#test-related")
  end
end
