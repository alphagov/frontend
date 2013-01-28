require_relative '../integration_test_helper'

class TravelAdviceTest < ActionDispatch::IntegrationTest

  context "a single country page" do
    setup do
      setup_api_responses "travel-advice/turks-and-caicos-islands"
    end

    should "display the travel advice page" do
      visit "/travel-advice/turks-and-caicos-islands"
      assert_equal 200, page.status_code

      within '.page-header' do
        assert page.has_content?("Travel advice")
        assert page.has_content?("Turks and Caicos Islands")
      end

      within '.page-navigation' do
        within 'li.active' do
          assert page.has_content?("Summary")
          assert page.has_content?("Current travel advice")
        end

        assert page.has_link?("Page Two", :href => "/travel-advice/turks-and-caicos-islands/page-two")
      end

      within 'article' do
        assert page.has_content?("Summary")

        assert page.has_content?("Current at #{Date.today.strftime("%e %B %Y")}")
        assert page.has_content?("Last updated 16 January 2013")

        assert page.has_content?("This is the summary")
      end

      within '.meta-data' do
        assert page.has_link?("Printer friendly page", :href => "/travel-advice/turks-and-caicos-islands/print")
      end
    end

    should "not display part numbers" do
      visit "/travel-advice/turks-and-caicos-islands"

      assert !page.has_content?("Part 1")
    end

    context "print-friendly view" do
      setup do
        visit "/travel-advice/turks-and-caicos-islands/print"
      end

      should "respond with a status of success" do
        assert_equal 200, page.status_code
      end

      should "have all of the parts on a single page" do
        assert page.has_content?("Part 1: Summary")
        assert page.has_content?("Part 2: Page Two")
      end
    end
  end

  context "a country without a travel advice edition" do
    setup do
      setup_api_responses "travel-advice/portugal"
    end

    should "display a basic travel advice page" do
      visit "/travel-advice/portugal"
      assert_equal 200, page.status_code

      within '.page-header' do
        assert page.has_content?("Travel advice")
        assert page.has_content?("Portugal")
      end

      within '.page-navigation' do
        within 'li.active' do
          assert page.has_content?("Summary")
        end
      end

      within 'article' do
        assert page.has_content?("Summary")

        assert page.has_content?("Current at #{Date.today.strftime("%e %B %Y")}")
        assert page.has_content?("Last updated 10 January 2013")
      end
    end
  end

  should "return a not found response for a country which does not exist" do
    content_api_does_not_have_an_artefact "travel-advice/timbuktu"
    visit "/travel-advice/timbuktu"

    assert_equal 404, page.status_code
  end

  context "previewing a country page" do
    should "display the travel advice page" do
      setup_api_responses "travel-advice/turks-and-caicos-islands"

      visit "/travel-advice/turks-and-caicos-islands?edition=1"
      assert_equal 200, page.status_code

      within '.page-header' do
        assert page.has_content?("Travel advice")
        assert page.has_content?("Turks and Caicos Islands")
      end

      within '.page-navigation' do
        within 'li.active' do
          assert page.has_content?("Summary")
        end

        assert page.has_link?("Page Two", :href => "/travel-advice/turks-and-caicos-islands/page-two?edition=1")
      end

      within 'article' do
        assert page.has_content?("Summary")

        assert page.has_content?("Current at #{Date.today.strftime("%e %B %Y")}")
        assert page.has_content?("Last updated 16 January 2013")

        assert page.has_content?("This is the summary")
      end
    end
  end
end
