RSpec.describe "BankHolidays" do
  include CalendarHelpers
  include GovukAbTesting::RspecHelpers

  before do
    GovukAbTesting.configure do |config|
      config.acceptance_test_framework = :capybara
    end
    content_item = { base_path: "/bank-holidays", schema_name: "calendar", document_type: "calendar" }
    stub_content_store_has_item("/bank-holidays", content_item)
    mock_calendar_fixtures
  end

  context "AB testing spacing" do
    it "has spacing for the B variant" do
      Timecop.travel("2012-12-14")
      with_variant(BankHolidaysTest: "B") do
        visit "/bank-holidays"

        within("#content") do
          expect(page).to have_selector(".bank-hols")
        end
      end
    end

    it "does not have additional spacing for the A variant" do
      Timecop.travel("2012-12-14")
      with_variant(BankHolidaysTest: "A") do
        visit "/bank-holidays"

        within("#content") do
          expect(page).not_to have_selector(".bank-hols")
        end
      end
    end
  end

  it "displays the bank holidays page" do
    Timecop.travel("2012-12-14")
    visit "/bank-holidays"

    within("head", visible: false) do
      expect(page).to have_selector("title", text: "UK bank holidays - GOV.UK", visible: false)
      desc = page.find("meta[name=description]", visible: false)
      expect(desc["content"]).to eq("Find out when bank holidays are in England, Wales, Scotland and Northern Ireland - including past and future bank holidays")
      expect(page).to have_selector("link[rel=alternate][type='application/json'][href='/bank-holidays.json']", visible: false)
      expect(page).to have_selector("link[rel=alternate][type='application/json'][href='/bank-holidays/england-and-wales.json']", visible: false)
      expect(page).to have_selector("link[rel=alternate][type='text/calendar'][href='/bank-holidays/england-and-wales.ics']", visible: false)
      expect(page).to have_selector("link[rel=alternate][type='application/json'][href='/bank-holidays/scotland.json']", visible: false)
      expect(page).to have_selector("link[rel=alternate][type='text/calendar'][href='/bank-holidays/scotland.ics']", visible: false)
      expect(page).to have_selector("link[rel=alternate][type='application/json'][href='/bank-holidays/northern-ireland.json']", visible: false)
      expect(page).to have_selector("link[rel=alternate][type='text/calendar'][href='/bank-holidays/northern-ireland.ics']", visible: false)
    end

    within("#content") do
      within(".gem-c-title") do
        expect(page).to have_content("UK bank holidays")
      end

      within("article") do
        within(".govuk-tabs") do
          tab_labels = page.all("ul li a").map(&:text)
          expect(tab_labels).to eq(["England and Wales", "Scotland", "Northern Ireland"])
        end

        within(".govuk-tabs") do
          within("#england-and-wales") do
            expect(page).to have_link("Add bank holidays for England and Wales to your calendar", href: "/bank-holidays/england-and-wales.ics")

            expect(page).to have_bank_holiday_table(title: "Upcoming bank holidays in England and Wales", year: "2012", rows: [
              ["Date", "Day of the week", "Bank holiday"],
              ["25 December", "Tuesday", "Christmas Day"],
              ["26 December", "Wednesday", "Boxing Day"],
            ])

            expect(page).to have_bank_holiday_table(title: "Upcoming bank holidays in England and Wales", year: "2013", rows: [
              ["Date", "Day of the week", "Bank holiday"],
              ["1 January", "Tuesday", "New Year’s Day"],
              ["29 March", "Friday", "Good Friday"],
              ["1 April", "Monday", "Easter Monday"],
              ["6 May", "Monday", "Early May bank holiday"],
              ["27 May", "Monday", "Spring bank holiday"],
              ["26 August", "Monday", "Summer bank holiday"],
              ["25 December", "Wednesday", "Christmas Day"],
              ["26 December", "Thursday", "Boxing Day"],
            ])

            expect(page).to have_bank_holiday_table(title: "Past bank holidays in England and Wales", year: "2012", rows: [
              ["Date", "Day of the week", "Bank holiday"],
              ["27 August", "Monday", "Summer bank holiday"],
              ["5 June", "Tuesday", "Queen’s Diamond Jubilee (extra bank holiday)"],
              ["4 June", "Monday", "Spring bank holiday (substitute day)"],
              ["7 May", "Monday", "Early May bank holiday"],
              ["9 April", "Monday", "Easter Monday"],
              ["6 April", "Friday", "Good Friday"],
              ["2 January", "Monday", "New Year’s Day (substitute day)"],
            ])
          end

          within("#scotland") do
            expect(page).to have_link("Add bank holidays for Scotland to your calendar", href: "/bank-holidays/scotland.ics")

            expect(page).to have_bank_holiday_table(title: "Upcoming bank holidays in Scotland", year: "2012", rows: [
              ["Date", "Day of the week", "Bank holiday"],
              ["25 December", "Tuesday", "Christmas Day"],
              ["26 December", "Wednesday", "Boxing Day"],
            ])

            expect(page).to have_bank_holiday_table(title: "Upcoming bank holidays in Scotland", year: "2013", rows: [
              ["Date", "Day of the week", "Bank holiday"],
              ["1 January", "Tuesday", "New Year’s Day"],
              ["2 January", "Wednesday", "2nd January"],
              ["29 March", "Friday", "Good Friday"],
              ["6 May", "Monday", "Early May bank holiday"],
              ["27 May", "Monday", "Spring bank holiday"],
              ["5 August", "Monday", "Summer bank holiday"],
              ["2 December", "Monday", "St Andrew’s Day (substitute day)"],
              ["25 December", "Wednesday", "Christmas Day"],
              ["26 December", "Thursday", "Boxing Day"],
            ])

            expect(page).to have_bank_holiday_table(title: "Past bank holidays in Scotland", year: "2012", rows: [
              ["Date", "Day of the week", "Bank holiday"],
              ["30 November", "Friday", "St Andrew’s Day"],
              ["6 August", "Monday", "Summer bank holiday"],
              ["5 June", "Tuesday", "Queen’s Diamond Jubilee (extra bank holiday)"],
              ["4 June", "Monday", "Spring bank holiday (substitute day)"],
              ["7 May", "Monday", "Early May bank holiday"],
              ["6 April", "Friday", "Good Friday"],
              ["3 January", "Tuesday", "New Year’s Day (substitute day)"],
              ["2 January", "Monday", "2nd January"],
            ])
          end

          within("#northern-ireland") do
            expect(page).to have_link("Add bank holidays for Northern Ireland to your calendar", href: "/bank-holidays/northern-ireland.ics")

            expect(page).to have_bank_holiday_table(title: "Upcoming bank holidays in Northern Ireland", year: "2012", rows: [
              ["Date", "Day of the week", "Bank holiday"],
              ["25 December", "Tuesday", "Christmas Day"],
              ["26 December", "Wednesday", "Boxing Day"],
            ])

            expect(page).to have_bank_holiday_table(title: "Upcoming bank holidays in Northern Ireland", year: "2013", rows: [
              ["Date", "Day of the week", "Bank holiday"],
              ["1 January", "Tuesday", "New Year’s Day"],
              ["18 March", "Monday", "St Patrick’s Day (substitute day)"],
              ["29 March", "Friday", "Good Friday"],
              ["1 April", "Monday", "Easter Monday"],
              ["6 May", "Monday", "Early May bank holiday"],
              ["27 May", "Monday", "Spring bank holiday"],
              ["12 July", "Friday", "Battle of the Boyne (Orangemen’s Day)"],
              ["26 August", "Monday", "Summer bank holiday"],
              ["25 December", "Wednesday", "Christmas Day"],
              ["26 December", "Thursday", "Boxing Day"],
            ])

            expect(page).to have_bank_holiday_table(title: "Past bank holidays in Northern Ireland", year: "2012", rows: [
              ["Date", "Day of the week", "Bank holiday"],
              ["27 August", "Monday", "Summer bank holiday"],
              ["12 July", "Thursday", "Battle of the Boyne (Orangemen’s Day)"],
              ["5 June", "Tuesday", "Queen’s Diamond Jubilee (extra bank holiday)"],
              ["4 June", "Monday", "Spring bank holiday"],
              ["7 May", "Monday", "Early May bank holiday"],
              ["9 April", "Monday", "Easter Monday"],
              ["6 April", "Friday", "Good Friday"],
              ["19 March", "Monday", "St Patrick’s Day (substitute day)"],
              ["2 January", "Monday", "New Year’s Day (substitute day)"],
            ])
          end
        end
      end
    end
  end

  it "displays the correct upcoming event" do
    Timecop.travel(Date.parse("2012-01-03")) do
      visit "/bank-holidays"

      within(".govuk-tabs") do
        within("#england-and-wales .govuk-panel") do
          expect(page).to have_content("The next bank holiday in England and Wales is")
          expect(page).to have_content("6 April")
          expect(page).to have_content("Good Friday")
        end

        within("#scotland .govuk-panel") do
          expect(page).to have_content("The next bank holiday in Scotland is")
          expect(page).to have_content("today")
          expect(page).to have_content("New Year\u2019s Day")
        end

        within("#northern-ireland .govuk-panel") do
          expect(page).to have_content("The next bank holiday in Northern Ireland is")
          expect(page).to have_content("19 March")
          expect(page).to have_content("St Patrick\u2019s Day")
        end
      end
    end
  end

  context "showing bunting on bank holidays" do
    it "shows bunting when today is a buntable bank holiday" do
      Timecop.travel(Date.parse("9th April 2012")) do
        visit "/bank-holidays"

        expect(page).to have_css(".app-bunting")
        expect(page).to have_css(".app-bunting--spacer")
      end
    end

    it "does not show bunting if today is a non-buntable bank holiday" do
      Timecop.travel(Date.parse("12th July 2013")) do
        visit "/bank-holidays"

        expect(page).not_to have_css(".app-bunting")
        expect(page).not_to have_css(".app-bunting--spacer")
      end
    end

    it "does not show bunting when today is not a bank holiday" do
      Timecop.travel(Date.parse("3rd Feb 2012")) do
        visit "/bank-holidays"

        expect(page).not_to have_css(".app-bunting")
        expect(page).not_to have_css(".app-bunting--spacer")
      end
    end

    it "does not use tinsel bunting in the middle of the year" do
      Timecop.travel(Date.parse("9th April 2012")) do
        visit "/bank-holidays"

        expect(page).not_to have_css(".app-bunting__tinsel")
      end
    end

    it "does not use tinsel bunting for bank holidays in early December" do
      Timecop.travel(Date.parse("2nd December 2013")) do
        visit "/bank-holidays"

        expect(page).not_to have_css(".app-bunting__tinsel")
      end
    end

    it "uses tinsel bunting for Christmas and New Year bank holidays" do
      Timecop.travel(Date.parse("25th December 2012")) do
        visit "/bank-holidays"

        expect(page).to have_css(".app-bunting__tinsel")
      end

      Timecop.travel(Date.parse("2nd Jan 2012")) do
        visit "/bank-holidays"

        expect(page).to have_css(".app-bunting__tinsel")
      end
    end
  end

  context "last updated" do
    it "is formatted correctly" do
      Timecop.travel(Date.parse("5th Dec 2012")) do
        visit "/bank-holidays"

        within(".gem-c-metadata") do
          expect(page).to have_content("Last updated 5 December 2012")
        end
      end
    end
  end

  context "GA4 tracking" do
    it "has GA4 tracking on the .ics file links" do
      visit "/bank-holidays"
      link_parents = page.all(".app-c-subscribe")
      link_parents.each do |link_parent|
        within(link_parent) do
          expect(link_parent).to have_selector("a[data-module='ga4-link-tracker']")

          ga4_link = link_parent.find("a[data-ga4-link]")["data-ga4-link"]
          ga4_expected_object = "{\"event_name\":\"file_download\",\"type\":\"generic download\"}"

          expect(ga4_expected_object).to eq(ga4_link)
        end
      end
    end
  end
end
