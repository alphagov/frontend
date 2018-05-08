require 'integration_test_helper'

class TransactionTest < ActionDispatch::IntegrationTest
  include GovukAbTesting::MinitestHelpers

  context "a transaction with all the optional things" do
    setup do
      @payload = {
        analytics_identifier: nil,
        base_path: "/carrots",
        content_id: "d6d6caaf-77db-47e1-8206-30cd4f3d0e3f",
        document_type: "transaction",
        first_published_at: "2016-02-29T09:24:10.000+00:00",
        locale: "en",
        phase: "beta",
        public_updated_at: "2012-10-22T12:49:50.000+00:00",
        publishing_app: "publisher",
        rendering_app: "frontend",
        schema_name: "transaction",
        title: "Carrots",
        updated_at: "2012-10-22T12:30:33.483Z",
        withdrawn_notice: {},
        links: {},
        description: "Descriptive carrots text.",
        details: {
          introductory_paragraph: "This is the introduction to carrots",
          transaction_start_link: 'http://carrots.example.com',
          will_continue_on: 'Carrotworld',
          start_button_text: 'Eat Carrots Now',
          what_you_need_to_know: 'Includes carrots',
          downtime_message: 'CarrotServe will be offline next week.'
        },
        external_related_links: []
      }

      content_store_has_item('/carrots', @payload)
    end

    should "render the main information" do
      visit "/carrots"

      assert_equal 200, page.status_code

      within 'head', visible: :all do
        assert page.has_selector?("title", text: "Carrots - GOV.UK", visible: false)
      end

      within '#content' do
        within 'header' do
          assert_has_component_title "Carrots"
        end

        within '.article-container' do
          within 'section.intro' do
            assert page.has_selector?(".get-started-intro", text: 'This is the introduction to carrots')

            assert_has_button_as_link("Eat Carrots Now",
                                        href: "http://carrots.example.com",
                                        start: true,
                                        rel: "external")

            assert page.has_content?('Carrotworld')
          end

          assert page.has_selector?(".modified-date", text: "Last updated: 22 October 2012")
        end
      end

      within('.help-notice') do
        assert page.has_content?('CarrotServe will be offline next week.')
      end
    end
  end

  context "jobsearch special page" do
    should "render ok" do
      content_store_has_example_item('/jobsearch', schema: 'transaction', example: 'jobsearch')
      visit '/jobsearch'

      assert_equal 200, page.status_code
      assert_selector('.jobsearch-form', visible: true)
    end
  end

  context "start page which should have cross domain analytics" do
    should "include cross domain analytics javascript" do
      content_store_has_example_item('/foo', schema: 'transaction', example: 'transaction')
      visit "/foo"

      assert_equal 200, page.status_code
      assert_has_button_as_link("Start now",
                                  rel: "external",
                                  href: "http://cti.voa.gov.uk/cti/inits.asp",
                                  start: true,
                                  data_attributes: {
                                    "module" => "cross-domain-tracking",
                                    "tracking-code" => "UA-12345-6",
                                    "tracking-name" => "transactionTracker"
                                  })
    end
  end

  context "start page format which shouldn't have cross domain analytics" do
    should "not include cross domain analytics javascript" do
      content_store_has_example_item('/foo', schema: 'transaction', example: 'jobsearch')
      visit "/foo"

      assert_equal 200, page.status_code
      assert_has_button_as_link("Start now",
                                  rel: "external",
                                  start: true,
                                  href: "https://jobsearch.direct.gov.uk/JobSearch/PowerSearch.aspx")
    end
  end

  context "locale is 'cy'" do
    setup do
      @payload = {
        base_path: "/cymraeg",
        content_id: "d6d6caaf-77db-47e1-8206-30cd4f3d0e3f",
        document_type: "transaction",
        locale: "cy",
        publishing_app: "publisher",
        rendering_app: "frontend",
        schema_name: "transaction",
        title: "Cymraeg",
        description: "Cynnwys Cymraeg",
        details: {
          transaction_start_link: 'http://cymraeg.example.com',
          start_button_text: "Start now",
        },
      }
      content_store_has_item("/cymraeg", @payload)
    end

    should "render start button text 'Dechrau nawr'" do
      visit "/cymraeg"

      within ".article-container" do
        within "section.intro" do
          assert_has_button_as_link("Dechrau nawr",
                                      rel: "external",
                                      start: true,
                                      href: "http://cymraeg.example.com")
        end
      end
    end
  end
end
