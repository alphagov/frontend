require "integration_test_helper"

class AnswerTest < ActionDispatch::IntegrationTest
  context "rendering an answer page" do
    setup do
      @payload = {
        analytics_identifier: nil,
        base_path: "/mice",
        content_id: "d6d6caaf-77db-47e1-8206-30cd4f3d0e3f",
        document_type: "answer",
        first_published_at: "2016-02-29T09:24:10.000+00:00",
        locale: "cy",
        need_ids: [],
        phase: "beta",
        public_updated_at: "2014-12-16T12:49:50.000+00:00",
        publishing_app: "publisher",
        rendering_app: "frontend",
        schema_name: "answer",
        title: "Mice",
        updated_at: "2017-01-30T12:30:33.483Z",
        withdrawn_notice: {},
        links: {},
        description: "Descriptive mice text.",
        details: {
          body: "This is the page about mice"
        },
        external_related_links: []
      }

      content_store_has_item('/mice', @payload)
    end

    should "render an answer page" do
      visit "/mice"

      assert_equal 200, page.status_code

      within 'head', visible: :all do
        assert page.has_selector?("title", text: "Mice", visible: :all)
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/mice.json']", visible: :all)
      end

      within '#content' do
        within 'header' do
          assert page.has_content?("Mice")
        end

        within '.article-container' do
          assert page.has_content?("This is the page about mice")
          assert page.has_selector?(shared_component_selector('beta_label'))
        end
      end # within #content

      assert_breadcrumb_rendered
      assert_related_items_rendered
    end

    should "render an answer in Welsh correctly" do
      # Note, this is using an English piece of content set to Welsh
      # This is fine because we're testing the page furniture, not the rendering of the content.
      visit "/mice"

      assert_equal 200, page.status_code

      within '#content' do
        within 'header' do
          assert page.has_content?("Mice")
        end

        within '.article-container' do
          assert page.has_selector?(".modified-date", text: "Diweddarwyd diwethaf: 30 Ionawr 2017")
        end
      end # within #content
    end
  end

  context "when previously a format with parts" do
    should "reroute to the base slug if requested with part route" do
      content_store_has_random_item_not_tagged_to_taxon(base_path: '/mice', schema: 'answer')

      visit "/mice/old-part-route"
      assert_current_url "/mice"
    end
  end
end
