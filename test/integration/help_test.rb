# encoding: utf-8
require "integration_test_helper"

class HelpTest < ActionDispatch::IntegrationTest
  context "rendering a help page" do
    setup do
      @payload = {
        analytics_identifier: nil,
        base_path: "/help/cookies",
        content_id: "d6d6caaf-77db-47e1-8206-30cd4f3d0e3f",
        document_type: "help_page",
        first_published_at: "2016-02-29T09:24:10.000+00:00",
        format: "help_page",
        locale: "en",
        need_ids: [],
        phase: "live",
        public_updated_at: "2014-12-16T12:49:50.000+00:00",
        publishing_app: "publisher",
        rendering_app: "frontend",
        schema_name: "help_page",
        title: "Cookies",
        updated_at: "2017-01-30T12:30:33.483Z",
        withdrawn_notice: {},
        links: {},
        description: "Descriptive cookie text.",
        details: {
          body: "This is the page about cookies"
        },
        external_related_links: []
      }

      content_store_has_item('/help/cookies', @payload)
    end

    should "render a help page" do

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
          assert page.has_content?(@payload[:details][:body])

          assert page.has_selector?(".modified-date", text: "Last updated: 30 January 2017")
        end
      end # within #content

      assert_breadcrumb_rendered
      assert_related_items_rendered
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
