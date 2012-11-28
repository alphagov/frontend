require_relative '../integration_test_helper'

class AnswerRenderingTest < ActionDispatch::IntegrationTest

  context "rendering a quick answer" do
    should "quick_answer request" do
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
        end

        within '.article-container' do
          within 'article' do
            assert page.has_selector?(".highlight-answer p em", :text => "20%")
          end

          assert page.has_selector?(".modified-date", :text => "Last updated: 22 October 2012")

          assert page.has_selector?("#test-report_a_problem")
        end
      end # within #content

      assert page.has_selector?("#test-related")
    end
  end
end
