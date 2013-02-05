require_relative '../integration_test_helper'

class TravelAdviceTest < ActionDispatch::IntegrationTest

  # Necessary because Capybara's has_content? method normalizes spaces in the document
  # However, it doesn't normalize spaces in the query string, so if you're looking for a string
  # with 2 spaces in it (e.g. when the date is a single digit with a space prefix), it will fail.
  def de_dup_spaces(string)
    string.gsub(/ +/, ' ')
  end

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

        assert page.has_content?(de_dup_spaces "Still current at: #{Date.today.strftime("%e %B %Y")}")
        assert page.has_content?("Updated: 16 January 2013")

        within '.application-notice.help-notice' do
          assert page.has_content?("Avoid all travel to parts of the country")
          assert page.has_content?("Avoid all but essential travel to the whole country")
        end

        assert page.has_selector?("h3", :text => "This is the summary")
      end

      within '.meta-data' do
        assert page.has_link?("Printer friendly page", :href => "/travel-advice/turks-and-caicos-islands/print")
        assert ! page.has_selector?('.modified-date')
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
          assert page.has_content?(de_dup_spaces "Still current at: #{Date.today.strftime("%e %B %Y")}")
          assert page.has_content?("Updated: 16 January 2013")
          within '.application-notice.help-notice' do
            assert page.has_content?("Avoid all travel to parts of the country")
            assert page.has_content?("Avoid all but essential travel to the whole country")
          end
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
    end
  end

  context "a country with no parts" do
    setup do
      setup_api_responses "travel-advice/luxembourg"
    end

    should "display a simplified view with no part navigation" do
      visit "/travel-advice/luxembourg"
      assert_equal 200, page.status_code

      within 'head' do
        assert page.has_selector?("title", :text => "Luxembourg travel advice")
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/travel-advice%2Fluxembourg.json']")
      end

      within '.page-header' do
        assert page.has_content?("Travel advice")
        assert page.has_content?("Luxembourg")
      end

      assert ! page.has_selector?('.page-navigation')

      within 'article' do
        assert page.has_selector?("h1", :text => "Summary")

        assert page.has_content?(de_dup_spaces "Still current at: #{Date.today.strftime("%e %B %Y")}")
        assert page.has_content?("Updated: 31 January 2013")

        assert page.has_content?("There are no travel restrictions in place for Luxembourg.")

        assert page.has_selector?("p", :text => "There are no parts of Luxembourg that the FCO recommends avoiding.")
      end

      within '.meta-data' do
        assert page.has_link?("Printer friendly page", :href => "/travel-advice/luxembourg/print")
      end
    end

    should "display the print view correctly" do
      visit "/travel-advice/luxembourg/print"
      assert_equal 200, page.status_code

      within 'section[role=main]' do
        assert page.has_selector?('h1', :text => "Luxembourg travel advice")

        section_titles = page.all('article h1').map(&:text)
        assert_equal ['Summary'], section_titles

        within 'article#summary' do
          assert page.has_selector?("h1", :text => "Summary")
          assert page.has_content?(de_dup_spaces "Still current at: #{Date.today.strftime("%e %B %Y")}")
          assert page.has_content?("Updated: 31 January 2013")
          assert page.has_content?("There are no travel restrictions in place for Luxembourg.")
          assert page.has_selector?("p", :text => "There are no parts of Luxembourg that the FCO recommends avoiding.")
        end
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

      assert ! page.has_selector?('.page-navigation')

      within 'article' do
        assert page.has_content?("Summary")

        assert page.has_content?(de_dup_spaces "Still current at: #{Date.today.strftime("%e %B %Y")}")
        assert page.has_content?("Updated: 10 January 2013")

        assert page.has_content?("There are no travel restrictions in place for Portugal.")
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
          assert page.has_content?(de_dup_spaces "Still current at: #{Date.today.strftime("%e %B %Y")}")
          assert page.has_content?("Updated: 10 January 2013")
          assert page.has_content?("There are no travel restrictions in place for Portugal.")
        end
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

        assert page.has_content?(de_dup_spaces "Still current at: #{Date.today.strftime("%e %B %Y")}")
        assert page.has_content?("Updated: 16 January 2013")

        assert page.has_content?("This is the summary")
      end
    end
  end

  context "a country RSS feed" do
    setup do
      setup_api_responses "travel-advice/portugal"
    end
    should "display the RSS feed for a country" do
      visit "/travel-advice/portugal.rss"

      assert_equal 200, page.status_code
      assert page.has_content? "Portugal"
    end
  end
end
