require 'integration_test_helper'
require "gds_api/test_helpers/content_store"

class TravelAdviceTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::ContentStore

  # Necessary because Capybara's has_content? method normalizes spaces in the document
  # However, it doesn't normalize spaces in the query string, so if you're looking for a string
  # with 2 spaces in it (e.g. when the date is a single digit with a space prefix), it will fail.
  def de_dup_spaces(string)
    string.gsub(/ +/, ' ')
  end

  context "travel advice index" do
    setup do
      json = GovukContentSchemaTestHelpers::Examples.new.get('travel_advice_index', 'index')
      content_item = JSON.parse(json)
      content_item["details"]["countries"].reverse!
      base_path = content_item.fetch("base_path")

      content_store_has_item(base_path, content_item)
    end

    should "display the list of countries" do
      visit '/foreign-travel-advice'
      assert_equal 200, page.status_code

      within 'head', visible: :all do
        assert page.has_selector?("title", text: "Foreign travel advice", visible: :all)
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/foreign-travel-advice.json']", visible: :all)
        assert page.has_selector?("link[rel=alternate][type='application/atom+xml'][href='/foreign-travel-advice.atom']", visible: :all)
        assert page.has_selector?("meta[name=description][content='Latest travel advice by country including safety and security, entry requirements, travel warnings and health']", visible: false)
      end

      assert page.has_selector?("#wrapper.travel-advice.guide")

      within '#content' do
        within 'header' do
          assert page.has_content?("Foreign travel advice")
        end

        assert page.has_selector?("#country-filter")

        names = page.all("ul.countries li a").map(&:text)
        assert_equal %w(Afghanistan Austria Finland India Malaysia Spain), names

        within ".list#A" do
          assert page.has_link?("Afghanistan", href: "/foreign-travel-advice/afghanistan")
        end

        within ".list#M" do
          assert page.has_link?("Malaysia", href: "/foreign-travel-advice/malaysia")
        end

        within ".list#S" do
          assert page.has_link?("Spain", href: "/foreign-travel-advice/spain")
        end
      end

      group_headers = page.all(".list h2").map(&:text)
      assert_equal group_headers.sort, group_headers

      within '#global-breadcrumb nav' do
        assert page.has_selector?("li:nth-child(1) a[href='/']", text: "Home")
        assert page.has_selector?("li:nth-child(2) a", text: "Passports, travel and living abroad")
        assert page.has_selector?("li:nth-child(3) a", text: "Travel abroad")
      end
    end

    should "set the slimmer #wrapper classes" do
      visit '/foreign-travel-advice'
      assert_equal "travel-advice guide", page.find("#wrapper")["class"]
    end

    should "return a 405 for POST requests" do
      post "/foreign-travel-advice"
      assert_equal 405, response.status
    end

    should "add the publishing request id in a meta tag" do
      visit "/foreign-travel-advice"
      assert page.has_css?("meta[name='govuk:publishing-request-id'][content='2546-1460985144476-19268198-3242']", visible: false)
    end
  end

  context "with the javascript driver" do
    setup do
      json = GovukContentSchemaTestHelpers::Examples.new.get('travel_advice_index', 'index')
      content_item = JSON.parse(json)
      base_path = content_item.fetch("base_path")
      content_store_has_item(base_path, content_item)

      Capybara.current_driver = Capybara.javascript_driver
    end

    should "load the page and perform filtering correctly" do
      visit "/foreign-travel-advice"
      assert_equal 200, page.status_code

      # For some reason PhantomJS isn't executing this script at the top of the <body> element,
      # so we have to repeat it here.
      page.execute_script %Q(document.body.className = ((document.body.className) ? document.body.className + ' js-enabled' : 'js-enabled');)

      assert page.has_selector?("#country-filter")

      within "#country-filter" do
        fill_in "country", with: "In"
      end

      within ".countries-wrapper" do
        assert page.has_selector?("#I li") # _In_dia
        assert page.has_selector?("#F li") # F_in_land
        assert page.has_selector?("#S li") # Spa_in_
        assert page.has_no_selector?("#A li")
        assert page.has_no_selector?("#M li")
      end

      within ".country-count" do
        assert page.has_selector?(".js-filter-count", text: "3")
      end
    end
  end

  context "a single country page" do
    setup do
      setup_api_responses "foreign-travel-advice/turks-and-caicos-islands"
    end

    should "display the travel advice page" do
      visit "/foreign-travel-advice/turks-and-caicos-islands"
      assert_equal 200, page.status_code

      within 'head', visible: :all do
        assert page.has_selector?("title", text: "Turks and Caicos Islands extra special travel advice", visible: :all)
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/foreign-travel-advice/turks-and-caicos-islands.json']", visible: :all)
        assert page.has_selector?("link[rel=alternate][type='application/atom+xml'][href='/foreign-travel-advice/turks-and-caicos-islands.atom']", visible: :all)
        assert page.has_selector?("meta[name=description][content='Latest travel advice by country including safety and security, entry requirements, travel warnings and health']", visible: false)
      end

      within '#global-breadcrumb nav' do
        assert page.has_selector?("li:nth-child(1) a[href='/']", text: "Home")
        assert page.has_selector?("li:nth-child(2) a", text: "Passports, travel and living abroad")
        assert page.has_selector?("li:nth-child(3) a", text: "Travel abroad")
        assert page.has_selector?("li:nth-child(4) a[href='/foreign-travel-advice']", text: "Foreign travel advice")
      end

      within '.page-header' do
        assert page.has_content?("Foreign travel advice")
        assert page.has_content?("Turks and Caicos Islands")
      end

      assert page.has_link?("Print entire guide", href: "/foreign-travel-advice/turks-and-caicos-islands/print")

      within '.page-navigation' do
        link_titles = page.all('.part-title').map(&:text)
        assert_equal ['Summary', 'Page Two', 'The Bridge of Death'], link_titles

        within 'li.active' do
          assert page.has_content?("Summary")
          assert page.has_content?("Current travel advice")
        end

        assert page.has_link?("Page Two", href: "/foreign-travel-advice/turks-and-caicos-islands/page-two")
        assert page.has_link?("The Bridge of Death", href: "/foreign-travel-advice/turks-and-caicos-islands/the-bridge-of-death")
      end

      within '.subscriptions' do
        assert page.has_link?("RSS", href: "/foreign-travel-advice/turks-and-caicos-islands.atom")
      end

      assert page.has_selector?("h1", text: "Summary")

      within '.country-metadata' do
        assert page.has_content?(de_dup_spaces "Still current at: #{Date.today.strftime("%e %B %Y")}")
        assert page.has_content?("Updated: 23 April 2013")
        assert page.has_selector?("p", text: "The issue with the Knights of Ni has been resolved.")
      end

      within '.application-notice.help-notice' do
        assert page.has_content?("The FCO advise against all travel to parts of the country")
        assert page.has_content?("The FCO advise against all but essential travel to the whole country")
        assert page.has_selector?("abbr[title='Foreign and Commonwealth Office']", text: "FCO", count: 2)
      end

      assert page.has_selector?("img[src='https://assets.digital.cabinet-office.gov.uk/media/512c9019686c82191d000001/darth-on-a-cat.jpg']")
      within ".form-download" do
        assert page.has_link?("Download map (PDF)", href: "https://assets.digital.cabinet-office.gov.uk/media/512c9019686c82191d000002/cookie-monster.pdf")
      end

      assert page.has_selector?("h3", text: "This is the summary")

      within '.article-container' do
        assert ! page.has_selector?('.modified-date')
      end

      within('.page-navigation') { click_on "Page Two" }
      assert_equal 200, page.status_code

      within 'head', :visible => :all do
        assert page.has_selector?("title", text: "Turks and Caicos Islands extra special travel advice", visible: :all)
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/foreign-travel-advice/turks-and-caicos-islands.json']", visible: :all)
      end

      within '.page-header' do
        assert page.has_content?("Foreign travel advice")
        assert page.has_content?("Turks and Caicos Islands")
      end

      within '.page-navigation' do
        link_titles = page.all('.part-title').map(&:text)
        assert_equal ['Summary', 'Page Two', 'The Bridge of Death'], link_titles

        assert page.has_link?("Summary", href: "/foreign-travel-advice/turks-and-caicos-islands")
        within 'li.active' do
          assert page.has_content?("Page Two")
        end
        assert page.has_link?("The Bridge of Death", href: "/foreign-travel-advice/turks-and-caicos-islands/the-bridge-of-death")
      end

      assert page.has_selector?("h1", text: "Page Two")
      assert page.has_selector?("li", text: "We're all going on a summer holiday,")

      within('.page-navigation') { click_on "The Bridge of Death" }
      assert_equal 200, page.status_code

      within 'head', visible: :all do
        assert page.has_selector?("title", text: "Turks and Caicos Islands extra special travel advice", visible: :all)
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/foreign-travel-advice/turks-and-caicos-islands.json']", visible: :all)
      end

      within '.page-header' do
        assert page.has_content?("Foreign travel advice")
        assert page.has_content?("Turks and Caicos Islands")
      end

      within '.page-navigation' do
        link_titles = page.all('.part-title').map(&:text)
        assert_equal ['Summary', 'Page Two', 'The Bridge of Death'], link_titles

        assert page.has_link?("Summary", href: "/foreign-travel-advice/turks-and-caicos-islands")
        assert page.has_link?("Page Two", href: "/foreign-travel-advice/turks-and-caicos-islands/page-two")
        within 'li.active' do
          assert page.has_content?("The Bridge of Death")
        end
      end

      assert page.has_selector?("h1", text: "The Bridge of Death")
      assert page.has_selector?("li", text: "What...is your quest?")
    end

    should "display the print view of a country page" do
      visit "/foreign-travel-advice/turks-and-caicos-islands/print"
      assert_equal 200, page.status_code

      within 'main[role=main]' do
        assert page.has_selector?('h1', text: "Turks and Caicos Islands travel advice")

        section_titles = page.all('article h1').map(&:text)
        assert_equal ['Page Two', 'The Bridge of Death'], section_titles

        within '#summary' do
          assert page.has_selector?("h1", text: "Summary")
          assert page.has_content?(de_dup_spaces "Still current at: #{Date.today.strftime("%e %B %Y")}")
          assert page.has_content?("Updated: 23 April 2013")
          within '.application-notice.help-notice' do
            assert page.has_content?("The FCO advise against all travel to parts of the country")
            assert page.has_content?("The FCO advise against all but essential travel to the whole country")
          end
          assert page.has_selector?("h3", text: "This is the summary")
        end

        within '#page-two' do
          assert page.has_selector?("h1", text: "Page Two")
          assert page.has_selector?("li", text: "We're all going on a summer holiday,")
        end

        within '#the-bridge-of-death' do
          assert page.has_selector?("h1", text: "The Bridge of Death")
          assert page.has_selector?("li", text: "What...is your quest?")
        end
      end
    end
  end

  context "a country with no parts" do
    setup do
      setup_api_responses "foreign-travel-advice/luxembourg"
    end

    should "display a simplified view with no part navigation" do
      visit "/foreign-travel-advice/luxembourg"
      assert_equal 200, page.status_code

      within 'head', :visible => :all do
        assert page.has_selector?("title", text: "Luxembourg travel advice", visible: :all)
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/foreign-travel-advice/luxembourg.json']", visible: :all)
      end

      within '.page-header' do
        assert page.has_content?("Foreign travel advice")
        assert page.has_content?("Luxembourg")
      end

      assert ! page.has_selector?('.page-navigation')

      assert page.has_no_selector?("h1", :text => "Summary")

      assert page.has_content?(de_dup_spaces "Still current at: #{Date.today.strftime("%e %B %Y")}")
      assert page.has_content?("Updated: 31 January 2013")

      assert page.has_selector?("p", :text => "There are no parts of Luxembourg that the FCO recommends avoiding.")
    end

  end

  should "return a not found response for a country which does not exist" do
    content_api_does_not_have_an_artefact "foreign-travel-advice/timbuktu"
    visit "/foreign-travel-advice/timbuktu"

    assert_equal 404, page.status_code
  end

  context "previewing a country page" do
    should "display the travel advice page" do
      content_api_has_a_draft_artefact "foreign-travel-advice/turks-and-caicos-islands", 1, content_api_response("foreign-travel-advice/turks-and-caicos-islands")

      visit "/foreign-travel-advice/turks-and-caicos-islands?edition=1"
      assert_equal 200, page.status_code

      within '.page-header' do
        assert page.has_content?("Foreign travel advice")
        assert page.has_content?("Turks and Caicos Islands")
      end

      assert page.has_link?("Print entire guide", href: "/foreign-travel-advice/turks-and-caicos-islands/print?edition=1")

      within '.page-navigation' do
        within 'li.active' do
          assert page.has_content?("Summary")
        end

        assert page.has_link?("Page Two", href: "/foreign-travel-advice/turks-and-caicos-islands/page-two?edition=1")
      end

      assert page.has_content?("Summary")

      assert page.has_content?(de_dup_spaces "Still current at: #{Date.today.strftime("%e %B %Y")}")
      assert page.has_content?("Updated: 23 April 2013")

      assert page.has_content?("This is the summary")
    end
  end
end
