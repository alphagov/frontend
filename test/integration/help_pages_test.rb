# encoding: utf-8
require "integration_test_helper"

class HelpPagesTest < ActionDispatch::IntegrationTest
  context "rendering a help page" do
    should "render a help page" do
      setup_api_responses("help/cookies")

      visit "/help/cookies"

      assert_equal 200, page.status_code

      within 'head', visible: :all do
        assert page.has_selector?("title", text: "Cookies - GOV.UK", visible: :all)
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/help/cookies.json']", visible: :all)
      end

      within '#global-breadcrumb' do
        assert page.has_selector?("li:nth-child(1) a[href='/']", text: "Home")
        assert page.has_selector?("li:nth-child(2) a[href='/help']", text: "Help")
      end

      within '#content' do
        within 'header' do
          assert page.has_content?("Cookies")
          assert page.has_content?("Help")
        end

        within '.article-container' do
          assert page.has_selector?("p", text: "This is the page about cookies.")

          assert page.has_selector?(".modified-date", text: "Last updated: 23 August 2013")
        end
      end # within #content

      assert page.has_selector?("#test-related")
    end
  end

  context "rendering the help index page" do
    setup do
      setup_api_responses('help')
    end

    should "render the help index page correctly" do
      visit "/help"

      within '#global-breadcrumb' do
        assert page.has_selector?("li:nth-child(1) a[href='/']", text: "Home")
      end

      within '#content header' do
        assert page.has_content?("Help using GOV.UK")
      end
    end
  end
end
