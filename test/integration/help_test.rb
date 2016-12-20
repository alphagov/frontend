# encoding: utf-8
require "integration_test_helper"

class HelpTest < ActionDispatch::IntegrationTest
  context "rendering a help page" do
    should "render a help page" do
      setup_api_responses("help/cookies")

      visit "/help/cookies"

      assert_equal 200, page.status_code

      within 'head', visible: :all do
        assert page.has_selector?("title", text: "Cookies - GOV.UK", visible: :all)
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/help/cookies.json']", visible: :all)
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

      assert_breadcrumb_rendered
      assert_related_items_rendered
    end

    should "render a help page edition in preview" do
      artefact = content_api_response("help/cookies")
      content_api_and_content_store_have_unpublished_page("help/cookies", 5, artefact)

      visit "/help/cookies?edition=5"

      assert_equal 200, page.status_code

      within '#content' do
        within '.article-container' do
          assert page.has_selector?("p", text: "This is the page about cookies.")
        end
      end # within #content

      assert_current_url "/help/cookies?edition=5"
    end
  end

  context "rendering the help index page" do
    setup do
      setup_api_responses('help')
    end

    should "render the help index page correctly" do
      visit "/help"

      assert_breadcrumb_rendered

      within '#content header' do
        assert page.has_content?("Help using GOV.UK")
      end
    end
  end
end
