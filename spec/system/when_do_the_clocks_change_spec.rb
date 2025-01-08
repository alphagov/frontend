RSpec.describe "When Do The Clocks Change" do
  include CalendarHelpers

  before do
    content_item = { base_path: "/when-do-the-clocks-change", schema_name: "calendar", document_type: "calendar" }
    stub_content_store_has_item("/when-do-the-clocks-change", content_item)
    mock_calendar_fixtures
  end

  it "displays the clocks change page" do
    visit "/when-do-the-clocks-change"
    within("head", visible: :hidden) do
      expect(page).to have_selector("title", text: "When do the clocks change? - GOV.UK", visible: :hidden)
      desc = page.find("meta[name=description]", visible: :hidden)

      expect(desc["content"]).to eq("Dates when the clocks go back or forward - includes British Summer Time, Greenwich Mean Time")
      expect(page).to have_selector("link[rel=alternate][type='application/json'][href='/when-do-the-clocks-change/united-kingdom.json']", visible: :hidden)
      expect(page).to have_selector("link[rel=alternate][type='text/calendar'][href='/when-do-the-clocks-change/united-kingdom.ics']", visible: :hidden)
    end

    within("#content") do
      within(".gem-c-title") do
        expect(page).to have_content("When do the clocks change?")
      end

      within("article") do
        rows = page.all(".app-c-calendar--clocks tr").map do |row|
          row.all("th,td").map(&:text)
        end
        expect(rows).to eq(
          [
            ["Year", "Clocks go forward", "Clocks go back"],
            ["2012", "25 March", "28 October"],
            ["2013", "31 March", "27 October"],
            ["2014", "30 March", "26 October"],
          ],
        )
        expect(page).to have_link("Add clock changes in the UK to your calendar (ICS, 2KB)", href: "/when-do-the-clocks-change/united-kingdom.ics")
      end
    end
  end

  it "displays the correct upcoming event" do
    Timecop.travel(Date.parse("2012-11-15")) do
      visit "/when-do-the-clocks-change"
      within(".govuk-panel") do
        expect(page).to have_content("The clocks go forward")
        expect(page).to have_content("31 March")
      end
    end

    Timecop.travel(Date.parse("2013-04-01")) do
      visit "/when-do-the-clocks-change"
      within(".govuk-panel") do
        expect(page).to have_content("The clocks go back")
        expect(page).to have_content("27 October")
      end
    end
  end
end
