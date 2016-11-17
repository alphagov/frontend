require "integration_test_helper"

class AnswerTest < ActionDispatch::IntegrationTest
  context "rendering an answer page" do
    should "render an answer page" do
      setup_api_responses('vat-rates')
      visit "/vat-rates"

      assert_equal 200, page.status_code

      within 'head', visible: :all do
        assert page.has_selector?("title", text: "VAT rates - GOV.UK", visible: :all)
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/vat-rates.json']", visible: :all)
      end

      within '#content' do
        within 'header' do
          assert page.has_content?("VAT rates")
        end

        within '.article-container' do
          assert page.has_selector?(".highlight-answer p em", text: "20%")
          assert page.has_selector?(shared_component_selector('beta_label'))
          assert page.has_selector?(".modified-date", text: "Last updated: 2 October 2012")
        end
      end # within #content

      assert_breadcrumb_rendered
      assert_related_items_rendered
    end

    should "render an answer page edition in preview" do
      artefact = content_api_response("vat-rates")
      content_api_and_content_store_have_unpublished_page("vat-rates", 5, artefact)

      visit "/vat-rates?edition=5"

      assert_equal 200, page.status_code

      within '#content' do
        within 'header' do
          assert page.has_content?("VAT rates")
        end
      end # within #content

      assert_current_url "/vat-rates?edition=5"
    end

    should "render an answer in Welsh correctly" do
      # Note, this is using an English piece of content set to Welsh
      # This is fine because we're testing the page furniture, not the rendering of the content.
      artefact = content_api_response('vat-rates')
      artefact["details"]["language"] = "cy"
      content_api_and_content_store_have_page('vat-rates', artefact)

      visit "/vat-rates"

      assert_equal 200, page.status_code

      within '#content' do
        within 'header' do
          assert page.has_content?("VAT rates")
        end

        within '.article-container' do
          assert page.has_selector?(".modified-date", text: "Diweddarwyd diwethaf: 2 Hydref 2012")
        end
      end # within #content
    end
  end
end
