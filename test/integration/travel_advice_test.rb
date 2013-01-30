require_relative '../integration_test_helper'

class TravelAdviceTest < ActionDispatch::IntegrationTest

  context "country list" do
    setup do
      content_api_has_countries(
        "aruba" => "Aruba",
        "portugal" => "Portugal",
        "turks-and-caicos-islands" => "Turks and Caicos Islands"
      )
    end

    should "display the list of countries" do
      visit '/travel-advice'
      assert_equal 200, page.status_code

      within '#content' do
        within 'header' do
          assert page.has_content?("Quick answer")
          assert page.has_content?("Travel advice")
        end

        assert page.has_selector?(".article-container #test-report_a_problem")
      end

      within ".list#A" do
        assert page.has_link?("Aruba", :href => "/travel-advice/aruba")
      end

      within ".list#P" do
        assert page.has_link?("Portugal", :href => "/travel-advice/portugal")
      end

      within ".list#T" do
        assert page.has_link?("Turks and Caicos Islands", :href => "/travel-advice/turks-and-caicos-islands")
      end
    end
  end

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
