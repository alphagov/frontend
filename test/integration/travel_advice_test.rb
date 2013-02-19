require_relative '../integration_test_helper'

class TravelAdviceTest < ActionDispatch::IntegrationTest

  # Necessary because Capybara's has_content? method normalizes spaces in the document
  # However, it doesn't normalize spaces in the query string, so if you're looking for a string
  # with 2 spaces in it (e.g. when the date is a single digit with a space prefix), it will fail.
  def de_dup_spaces(string)
    string.gsub(/ +/, ' ')
  end

  context "travel advice index" do
    setup do
      setup_api_responses("foreign-travel-advice", :file => 'foreign-travel-advice/index1.json')
    end

    should "display the list of countries" do
      visit '/foreign-travel-advice'
      assert_equal 200, page.status_code

      assert page.has_selector?("#wrapper.travel-advice.guide")

      within '#content' do
        within 'header' do
          assert page.has_content?("Quick answer")
          assert page.has_content?("Foreign travel advice")
        end

        within "#recently-updated" do
          assert_equal ["Portugal", "Aruba", "Turks and Caicos Islands", "Congo", "Germany"],
                       page.all("li a").map(&:text)
          assert_equal ["updated 22 February 2013", "updated 20 February 2013", "updated 19 February 2013",
                        "updated  3 February 2013", "updated  2 February 2013"],
                       page.all("li span").map(&:text)
        end


        assert_equal ["Aruba", "Congo", "Germany", "Iran", "Portugal", "Turks and Caicos Islands"], page.all("ul.countries li a").map(&:text)
        within ".list#A" do
          assert page.has_link?("Aruba", :href => "/foreign-travel-advice/aruba")
        end

        within ".list#P" do
          assert page.has_link?("Portugal", :href => "/foreign-travel-advice/portugal")
        end

        within ".list#T" do
          assert page.has_link?("Turks and Caicos Islands", :href => "/foreign-travel-advice/turks-and-caicos-islands")
        end

        assert page.has_selector?(".article-container #test-report_a_problem")
      end # within #content

      assert page.has_selector?("#test-related")
    end

    context "filtering countries" do
      setup do
        visit '/foreign-travel-advice'
      end

      should "have a visible visible form" do
        assert_equal 200, page.status_code
        assert page.has_selector?("#country-filter", visible: true)
      end

      should "not show any countries if none match" do
        assert_equal 200, page.status_code

        within "#country-filter" do
          fill_in "country", :with => "z"
        end

        within "#A" do
          assert page.has_selector?("li", visible: false)
        end

        within "#P" do
          assert page.has_selector?("li", visible: false)
        end

        within "#T" do
          assert page.has_selector?("li", visible: false)
        end
      end

      should "show only countries that match" do
        assert_equal 200, page.status_code

        within "#country-filter" do
          fill_in "country", :with => "B"
        end

        within "#A" do
          assert page.has_selector?("li", visible: true)
        end

        within "#P" do
          assert page.has_selector?("li", visible: false)
        end

        within "#T" do
          assert page.has_selector?("li", visible: false)
        end
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

      within 'head' do
        assert page.has_selector?("title", :text => "Turks and Caicos Islands extra special travel advice")
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/foreign-travel-advice%2Fturks-and-caicos-islands.json']")
      end

      within '.page-header' do
        assert page.has_content?("Foreign travel advice")
        assert page.has_content?("Turks and Caicos Islands")
      end

      within '.page-navigation' do
        link_titles = page.all('.part-title').map(&:text)
        assert_equal ['Summary', 'Page Two', 'The Bridge of Death'], link_titles

        within 'li.active' do
          assert page.has_content?("Summary")
          assert page.has_content?("Current travel advice")
        end

        assert page.has_link?("Page Two", :href => "/foreign-travel-advice/turks-and-caicos-islands/page-two")
        assert page.has_link?("The Bridge of Death", :href => "/foreign-travel-advice/turks-and-caicos-islands/the-bridge-of-death")
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
        assert page.has_link?("Printer friendly page", :href => "/foreign-travel-advice/turks-and-caicos-islands/print")
        assert ! page.has_selector?('.modified-date')
      end

      within('.page-navigation') { click_on "Page Two" }
      assert_equal 200, page.status_code

      within 'head' do
        assert page.has_selector?("title", :text => "Turks and Caicos Islands extra special travel advice")
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/foreign-travel-advice%2Fturks-and-caicos-islands.json']")
      end

      within '.page-header' do
        assert page.has_content?("Foreign travel advice")
        assert page.has_content?("Turks and Caicos Islands")
      end

      within '.page-navigation' do
        link_titles = page.all('.part-title').map(&:text)
        assert_equal ['Summary', 'Page Two', 'The Bridge of Death'], link_titles

        assert page.has_link?("Summary", :href => "/foreign-travel-advice/turks-and-caicos-islands")
        within 'li.active' do
          assert page.has_content?("Page Two")
        end
        assert page.has_link?("The Bridge of Death", :href => "/foreign-travel-advice/turks-and-caicos-islands/the-bridge-of-death")
      end

      within 'article' do
        assert page.has_selector?("h1", :text => "Page Two")
        assert page.has_selector?("li", :text => "We're all going on a summer holiday,")
      end

      within('.page-navigation') { click_on "The Bridge of Death" }
      assert_equal 200, page.status_code

      within 'head' do
        assert page.has_selector?("title", :text => "Turks and Caicos Islands extra special travel advice")
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/foreign-travel-advice%2Fturks-and-caicos-islands.json']")
      end

      within '.page-header' do
        assert page.has_content?("Foreign travel advice")
        assert page.has_content?("Turks and Caicos Islands")
      end

      within '.page-navigation' do
        link_titles = page.all('.part-title').map(&:text)
        assert_equal ['Summary', 'Page Two', 'The Bridge of Death'], link_titles

        assert page.has_link?("Summary", :href => "/foreign-travel-advice/turks-and-caicos-islands")
        assert page.has_link?("Page Two", :href => "/foreign-travel-advice/turks-and-caicos-islands/page-two")
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
      visit "/foreign-travel-advice/turks-and-caicos-islands/print"
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
      setup_api_responses "foreign-travel-advice/luxembourg"
    end

    should "display a simplified view with no part navigation" do
      visit "/foreign-travel-advice/luxembourg"
      assert_equal 200, page.status_code

      within 'head' do
        assert page.has_selector?("title", :text => "Luxembourg travel advice")
        assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/foreign-travel-advice%2Fluxembourg.json']")
      end

      within '.page-header' do
        assert page.has_content?("Foreign travel advice")
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
        assert page.has_link?("Printer friendly page", :href => "/foreign-travel-advice/luxembourg/print")
      end
    end

    should "display the print view correctly" do
      visit "/foreign-travel-advice/luxembourg/print"
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

      within '.page-navigation' do
        within 'li.active' do
          assert page.has_content?("Summary")
        end

        assert page.has_link?("Page Two", :href => "/foreign-travel-advice/turks-and-caicos-islands/page-two?edition=1")
      end

      within 'article' do
        assert page.has_content?("Summary")

        assert page.has_content?(de_dup_spaces "Still current at: #{Date.today.strftime("%e %B %Y")}")
        assert page.has_content?("Updated: 16 January 2013")

        assert page.has_content?("This is the summary")
      end

      within '.meta-data' do
        assert page.has_link?("Printer friendly page", :href => "/foreign-travel-advice/turks-and-caicos-islands/print?edition=1")
      end
    end
  end
end
