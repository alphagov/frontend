require_relative '../integration_test_helper'

class TravelAdviceTest < ActionDispatch::IntegrationTest

  context "a single country page" do
    setup do
      setup_api_responses "travel-advice/turks-and-caicos-islands"
    end

    should "display the travel advice page" do
      visit "/travel-advice/turks-and-caicos-islands"
      assert_equal 200, page.status_code

      within 'head' do
        assert page.has_selector?("title", :text => "Turks and Caicos Islands extra special travel advice")
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/travel-advice%2Fturks-and-caicos-islands.json']")
      end

      within '.page-header' do
        assert page.has_content?("Travel advice")
        assert page.has_content?("Turks and Caicos Islands")
      end

      within '.page-navigation' do
        link_titles = page.all('.part-title').map(&:text)
        assert_equal ['Summary', 'Page Two', 'The Bridge of Death'], link_titles

        within 'li.active' do
          assert page.has_content?("Summary")
          assert page.has_content?("Current travel advice")
        end

        assert page.has_link?("Page Two", :href => "/travel-advice/turks-and-caicos-islands/page-two")
        assert page.has_link?("The Bridge of Death", :href => "/travel-advice/turks-and-caicos-islands/the-bridge-of-death")
      end

      within 'article' do
        assert page.has_selector?("h1", :text => "Summary")

        assert page.has_content?("Current at #{Date.today.strftime("%e %B %Y")}")
        assert page.has_content?("Last updated 16 January 2013")

        assert page.has_selector?("h3", :text => "This is the summary")
      end

      within '.meta-data' do
        assert page.has_link?("Printer friendly page", :href => "/travel-advice/turks-and-caicos-islands/print")
      end

      within('.page-navigation') { click_on "Page Two" }
      assert_equal 200, page.status_code

      within 'head' do
        assert page.has_selector?("title", :text => "Turks and Caicos Islands extra special travel advice")
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/travel-advice%2Fturks-and-caicos-islands.json']")
      end

      within '.page-header' do
        assert page.has_content?("Travel advice")
        assert page.has_content?("Turks and Caicos Islands")
      end

      within '.page-navigation' do
        link_titles = page.all('.part-title').map(&:text)
        assert_equal ['Summary', 'Page Two', 'The Bridge of Death'], link_titles

        assert page.has_link?("Summary", :href => "/travel-advice/turks-and-caicos-islands")
        within 'li.active' do
          assert page.has_content?("Page Two")
        end
        assert page.has_link?("The Bridge of Death", :href => "/travel-advice/turks-and-caicos-islands/the-bridge-of-death")
      end

      within 'article' do
        assert page.has_selector?("h1", :text => "Page Two")
        assert page.has_selector?("li", :text => "We're all going on a summer holiday,")
      end

      within('.page-navigation') { click_on "The Bridge of Death" }
      assert_equal 200, page.status_code

      within 'head' do
        assert page.has_selector?("title", :text => "Turks and Caicos Islands extra special travel advice")
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/travel-advice%2Fturks-and-caicos-islands.json']")
      end

      within '.page-header' do
        assert page.has_content?("Travel advice")
        assert page.has_content?("Turks and Caicos Islands")
      end

      within '.page-navigation' do
        link_titles = page.all('.part-title').map(&:text)
        assert_equal ['Summary', 'Page Two', 'The Bridge of Death'], link_titles

        assert page.has_link?("Summary", :href => "/travel-advice/turks-and-caicos-islands")
        assert page.has_link?("Page Two", :href => "/travel-advice/turks-and-caicos-islands/page-two")
        within 'li.active' do
          assert page.has_content?("The Bridge of Death")
        end
      end

      within 'article' do
        assert page.has_selector?("h1", :text => "The Bridge of Death")
        assert page.has_selector?("li", :text => "What...is your quest?")
      end
    end

    should "display the print view of a country page" do
      visit "/travel-advice/turks-and-caicos-islands/print"
      assert_equal 200, page.status_code

      within 'section[role=main]' do
        assert page.has_selector?('h1', :text => "Turks and Caicos Islands travel advice")

        section_titles = page.all('article h1').map(&:text)
        assert_equal ['Summary', 'Page Two', 'The Bridge of Death'], section_titles

        within 'article#summary' do
          assert page.has_selector?("h1", :text => "Summary")
          assert page.has_selector?("h3", :text => "This is the summary")
        end

        within 'article#page-two' do
          assert page.has_selector?("h1", :text => "Page Two")
          assert page.has_selector?("li", :text => "We're all going on a summer holiday,")
        end

        within 'article#the-bridge-of-death' do
          assert page.has_selector?("h1", :text => "The Bridge of Death")
          assert page.has_selector?("li", :text => "What...is your quest?")
        end
      end
      assert page.has_content?("Last updated: 16 January 2013")
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

    should "display a basic print view" do
      visit "/travel-advice/portugal/print"

      within 'section[role=main]' do
        assert page.has_selector?('h1', :text => "Portugal travel advice")

        section_titles = page.all('article h1').map(&:text)
        assert_equal ['Summary'], section_titles

        within 'article#summary' do
          assert page.has_selector?("h1", :text => "Summary")
        end
      end
      assert page.has_content?("Last updated: 10 January 2013")
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
