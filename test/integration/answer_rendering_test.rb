# encoding: utf-8
require_relative '../integration_test_helper'

class AnswerRenderingTest < ActionDispatch::IntegrationTest

  should "rendering a quick answer correctly" do
    setup_api_responses('vat-rates')
    visit "/vat-rates"

    assert_equal 200, page.status_code

    within 'head' do
      assert page.has_selector?("title", :text => "VAT rates - GOV.UK")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/vat-rates.json']")
    end

    within '#content' do
      within 'header' do
        assert page.has_content?("VAT rates")
        assert page.has_content?("Quick answer")
        assert page.has_link?("Not what you're looking for? ↓", :href => "#related")
      end

      within '.article-container' do
        within 'article' do
          assert page.has_selector?(".highlight-answer p em", :text => "20%")
        end

        assert page.has_selector?(".modified-date", :text => "Last updated:  2 October 2012")

        assert page.has_selector?("#test-report_a_problem")
      end
    end # within #content

    assert page.has_selector?("#test-related")
  end

  should "render a quick answer in welsh correctly" do
    # Note, this is using an english piece of content set to Welsh
    # This is fine because we're testing the page furniture, not the rendering of the content.
    artefact = content_api_response('vat-rates')
    artefact["details"]["language"] = "cy"
    content_api_has_an_artefact('vat-rates', artefact)

    visit "/vat-rates"

    assert_equal 200, page.status_code

    within '#content' do
      within 'header' do
        assert page.has_content?("VAT rates")
        assert page.has_content?("Ateb cyflym")
        assert page.has_link?("Ddim beth rydych chi’n chwilio amdano? ↓", :href => "#related")
      end

      within '.article-container' do
        assert page.has_selector?(".modified-date", :text => "Diweddarwyd diwethaf:  2 Hydref 2012")
      end
    end # within #content
  end
end
