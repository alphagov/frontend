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
        need_ids: [],
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
          assert page.has_content?('Carrots')
        end

        within '.article-container' do
          within 'section.intro' do
            assert page.has_selector?(".get-started-intro", text: 'This is the introduction to carrots')

            start_link = find_link("Eat Carrots Now")
            assert_equal 'http://carrots.example.com', start_link["href"]

            assert page.has_content?('Carrotworld')
          end

          assert page.has_selector?(".modified-date", text: "Last updated: 22 October 2012")
        end
      end

      within('.help-notice') do
        assert page.has_content?('CarrotServe will be offline next week.')
      end

      assert_breadcrumb_rendered
      assert_related_items_rendered
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
      assert_selector("#transaction_cross_domain_analytics", visible: :all, text: "UA-12345-6")
    end
  end

  context "start page format which shouldn't have cross domain analytics" do
    should "not include cross domain analytics javascript" do
      content_store_has_example_item('/foo', schema: 'transaction', example: 'jobsearch')
      visit "/foo"

      assert_equal 200, page.status_code
      assert page.has_no_selector?("#transaction_cross_domain_analytics", visible: :all)
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
          assert page.has_link?("Dechrau nawr")
        end
      end
    end
  end

  context "tasklist AB test on applicable content" do
    setup do
      TransactionController.any_instance.stubs(:tasklist_ab_test_applies?).returns(true)

      TasklistContent.stubs(:learn_to_drive_config).returns(
        title: "How to become a driver in the 1900s",
        description: "A step by step guide to driving Miss Daisy",
        tasklist: {
          heading_level: 3,
          small: true,
          steps: [
            [{
              title: "Prerequisites",
              panel_descriptions: [""],
              panel_links: [
                {
                  href: "/purchase-red-flag",
                  text: "Buy a red flag to wave ahead of your vehicle"
                },
                {
                  href: "/hire-flag-waver",
                  text: "Your flag needs someone to wave it"
                }
              ]
            }],
            [{
              title: "Final steps",
              panel_descriptions: ["Certain people require their motor vehicle to be driven in an appropriate fashion"],
              panel_links: [
                {
                  href: "/learn-to-drive-miss-daisy",
                  text: "Learn Miss Daisy's speed preferences"
                }
              ]
            }]
          ]
        }
       )
    end

    context "in bucket A" do
      should "not include tasklist sidebar" do
        with_variant TaskListSidebar: 'A' do
          content_store_has_example_item('/learn-to-drive-miss-daisy', schema: 'transaction')

          visit "/learn-to-drive-miss-daisy"

          assert page.has_no_selector?(".qa-tasklist-sidebar")
        end
      end
    end


    context "in bucket B" do
      setup do
        content_store_has_example_item('/hire-flag-waver', schema: 'transaction')
        content_store_has_example_item('/learn-to-drive-miss-daisy', schema: 'transaction')
      end

      should "include tasklist sidebar but not show the item as 'active' unless the page is in the tasklist config" do
        with_variant TaskListSidebar: 'B' do
          content_store_has_example_item('/sell-horses', schema: 'transaction')

          visit "/sell-horses"

          assert page.has_selector?(".qa-tasklist-sidebar")

          within_static_component('task_list') do |tasklist_args|
            assert_equal 2, tasklist_args[:steps].count

            assert_equal 3, tasklist_args[:heading_level]

            assert_equal [], tasklist_step_keys(tasklist_args) - %w(title panel panel_descriptions panel_links)

            assert_equal [], tasklist_panel_links_keys(tasklist_args) - %w(href text)
          end
        end
      end

      should "set the item as active if it is the current page" do
        visit "/hire-flag-waver"

        assert page.has_selector?(".qa-tasklist-sidebar")

        within_static_component('task_list') do |tasklist_args|
          assert_equal [], tasklist_panel_links_keys(tasklist_args) - %w(active href text)
        end
      end
    end
  end

  def tasklist_step_keys(tasklist_args)
    tasklist_args[:steps].flatten.flat_map(&:keys).uniq
  end

  def tasklist_panel_links_keys(tasklist_args)
    tasklist_args[:steps].flatten.flat_map { |step| step["panel_links"] }.flat_map(&:keys).uniq
  end
end
