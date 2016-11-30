require "integration_test_helper"

class BusinessSupportTest < ActionDispatch::IntegrationTest
  context "rendering a business support page page" do
    should "render a business support page" do
      setup_api_responses('business-support-example')
      visit "/business-support-example"

      assert_equal 200, page.status_code

      within '#content' do
        within 'header' do
          assert page.has_content?("Business support example")
        end

        assert page.has_content? "Provides UK businesses with free, quick and easy access to a directory of approved finance suppliers"
        assert page.has_content? "How much you can get"
        assert_match(/1 -.*?20,000,000/, page.text)
        assert page.has_content? "Eligibility"
        assert page.has_content? "Will depend on the individual provider."
        assert page.has_link? "Find out more", href: "http://www.businessfinanceforyou.co.uk/finance-finder"

        within '.nav-tabs' do
          assert page.has_link? "What you need to know"
          assert page.has_link? "Additional information"
        end
      end

      assert_breadcrumb_rendered
      assert_related_items_rendered
    end

    should "render a business support page page edition in preview" do
      artefact = content_api_response("business-support-example")
      content_api_and_content_store_have_unpublished_page("business-support-example", 5, artefact)

      visit "/business-support-example?edition=5"

      assert_equal 200, page.status_code

      within '#content' do
        within 'header' do
          assert page.has_content?("Business support example")
        end
      end

      assert_current_url "/business-support-example?edition=5"
    end

    should "render a business support page in Welsh correctly" do
      # Note, this is using an English piece of content set to Welsh
      # This is fine because we're testing the page furniture, not the rendering of the content.
      artefact = content_api_response('business-support-example')
      artefact["details"]["language"] = "cy"
      content_api_and_content_store_have_page('business-support-example', artefact)

      visit "/business-support-example"

      assert_equal 200, page.status_code

      within '#content' do
        within 'header' do
          assert page.has_content?("Business support example")
        end

        within '.article-container' do
          assert page.has_selector?(".modified-date", text: "Diweddarwyd diwethaf: 2 Hydref 2012")
        end
      end # within #content
    end
  end

  context "when previously a format with parts" do
    should "reroute to the base slug if requested with part route" do
      setup_api_responses('business-support-example')
      visit "/business-support-example/old-part-route"

      assert_current_url "/business-support-example"
    end
  end
end
