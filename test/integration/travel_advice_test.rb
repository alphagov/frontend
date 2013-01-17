require_relative '../integration_test_helper'

class TravelAdviceTest < ActionDispatch::IntegrationTest

  context "a single country page" do
    should "display the travel advice page" do
      setup_api_responses "travel-advice/turks-and-caicos-islands"

      visit "/travel-advice/turks-and-caicos-islands"
      assert_equal 200, page.status_code

      within '.page-header' do
        assert page.has_content?("Travel advice")
        assert page.has_content?("Turks and Caicos Islands")
      end

      within '.page-navigation' do
        within 'li.active' do
          assert page.has_content?("Summary")
        end

        assert page.has_link?("Page Two", :href => "/travel-advice/turks-and-caicos-islands/page-two")
      end

      within 'article' do
        assert page.has_content?("Summary")
        assert page.has_content?("This is the summary")
      end
    end

    should "not display part numbers" do
      setup_api_responses "travel-advice/turks-and-caicos-islands"

      visit "/travel-advice/turks-and-caicos-islands"

      assert !page.has_content?("Part 1")
    end
  end
end
