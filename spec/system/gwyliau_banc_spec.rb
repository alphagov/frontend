RSpec.describe "GwyliauBanc" do
  include CalendarHelpers

  before do
    content_item_cy = { base_path: "/gwyliau-banc", schema_name: "calendar", document_type: "calendar", locale: "cy" }
    stub_content_store_has_item("/gwyliau-banc", content_item_cy)
    content_item_en = { base_path: "/bank-holidays", schema_name: "calendar", document_type: "calendar" }
    stub_content_store_has_item("/bank-holidays", content_item_en)
    mock_calendar_fixtures
  end

  it "displays the Gwyliau Banc page" do
    Timecop.travel("2012-12-14")
    visit "/gwyliau-banc"

    within("head", visible: :hidden) do
      expect(page).to have_selector("title", text: "Gwyliau banc y DU - GOV.UK", visible: :hidden)
      desc = page.find("meta[name=description]", visible: :hidden)
      expect(desc["content"]).to eq("Dysgwch pryd mae gwyliau'r banc yng Nghymru, Lloegr, yr Alban a Gogledd Iwerddon - gan gynnwys gwyliau banc yn y gorffennol a'r dyfodol")
      expect(page).to have_selector("link[rel=alternate][type='application/json'][href='/gwyliau-banc.json']", visible: :hidden)
      expect(page).to have_selector("link[rel=alternate][type='application/json'][href='/gwyliau-banc/cymru-a-lloegr.json']", visible: :hidden)
      expect(page).to have_selector("link[rel=alternate][type='text/calendar'][href='/gwyliau-banc/cymru-a-lloegr.ics']", visible: :hidden)
      expect(page).to have_selector("link[rel=alternate][type='application/json'][href='/gwyliau-banc/yr-alban.json']", visible: :hidden)
      expect(page).to have_selector("link[rel=alternate][type='text/calendar'][href='/gwyliau-banc/yr-alban.ics']", visible: :hidden)
      expect(page).to have_selector("link[rel=alternate][type='application/json'][href='/gwyliau-banc/gogledd-iwerddon.json']", visible: :hidden)
      expect(page).to have_selector("link[rel=alternate][type='text/calendar'][href='/gwyliau-banc/gogledd-iwerddon.ics']", visible: :hidden)
    end

    within("#content") do
      within(".gem-c-heading") do
        expect(page).to have_content("Gwyliau banc y DU")
      end
      within("article") do
        within(".govuk-tabs") do
          tab_labels = page.all("ul li a").map(&:text)
          expect(tab_labels).to eq(["Cymru a Lloegr", "yr Alban", "Gogledd Iwerddon"])
        end
        within(".govuk-tabs") do
          within("#cymru-a-lloegr") do
            expect(page).to have_link("Ychwanegu'r gwyliau banc ar gyfer Cymru a Lloegr at eich calendr (ICS, 14KB)", href: "/gwyliau-banc/cymru-a-lloegr.ics")

            expect(page).to have_bank_holiday_table(title: "Gwyliau banc i ddod yng Nghymru a Lloegr", year: "2012", rows: [
              ["Dyddiad", "Diwrnod yr wythnos", "Gŵyl y banc"],
              ["25 Rhagfyr", "Dydd Mawrth", "Dydd Nadolig"],
              ["26 Rhagfyr", "Dydd Mercher", "Dydd San Steffan"],
            ])

            expect(page).to have_bank_holiday_table(title: "Gwyliau banc i ddod yng Nghymru a Lloegr", year: "2013", rows: [
              ["Dyddiad", "Diwrnod yr wythnos", "Gŵyl y banc"],
              ["1 Ionawr", "Dydd Mawrth", "Dydd Calan"],
              ["29 Mawrth", "Dydd Gwener", "Gwener y Groglith"],
              ["1 Ebrill", "Dydd Llun", "Llun y Pasg"],
              ["6 Mai", "Dydd Llun", "Gŵyl banc dechrau Mai"],
              ["27 Mai", "Dydd Llun", "Gŵyl banc y gwanwyn"],
              ["26 Awst", "Dydd Llun", "Gŵyl banc yr haf"],
              ["25 Rhagfyr", "Dydd Mercher", "Dydd Nadolig"],
              ["26 Rhagfyr", "Dydd Iau", "Dydd San Steffan"],
            ])

            expect(page).to have_bank_holiday_table(title: "Gwyliau banc blaenorol yng Nghymru a Lloegr", year: "2012", rows: [
              ["Dyddiad", "Diwrnod yr wythnos", "Gŵyl y banc"],
              ["27 Awst", "Dydd Llun", "Gŵyl banc yr haf"],
              ["5 Mehefin", "Dydd Mawrth", "Jiwbilî Ddiemwnt y Frenhines (gŵyl banc ychwanegol)"],
              ["4 Mehefin", "Dydd Llun", "Gŵyl banc y gwanwyn (diwrnod amgen)"],
              ["7 Mai", "Dydd Llun", "Gŵyl banc dechrau Mai"],
              ["9 Ebrill", "Dydd Llun", "Llun y Pasg"],
              ["6 Ebrill", "Dydd Gwener", "Gwener y Groglith"],
              ["2 Ionawr", "Dydd Llun", "Dydd Calan (diwrnod amgen)"],
            ])
          end

          within("#yr-alban") do
            expect(page).to have_link("Ychwanegu'r gwyliau banc ar gyfer yr Alban at eich calendr (ICS, 14KB)", href: "/gwyliau-banc/yr-alban.ics")

            expect(page).to have_bank_holiday_table(title: "Gwyliau banc i ddod yn yr Alban", year: "2012", rows: [
              ["Dyddiad", "Diwrnod yr wythnos", "Gŵyl y banc"],
              ["25 Rhagfyr", "Dydd Mawrth", "Dydd Nadolig"],
              ["26 Rhagfyr", "Dydd Mercher", "Dydd San Steffan"],
            ])

            expect(page).to have_bank_holiday_table(title: "Gwyliau banc i ddod yn yr Alban", year: "2013", rows: [
              ["Dyddiad", "Diwrnod yr wythnos", "Gŵyl y banc"],
              ["1 Ionawr", "Dydd Mawrth", "Dydd Calan"],
              ["2 Ionawr", "Dydd Mercher", "2il o Ionawr"],
              ["29 Mawrth", "Dydd Gwener", "Gwener y Groglith"],
              ["6 Mai", "Dydd Llun", "Gŵyl banc dechrau Mai"],
              ["27 Mai", "Dydd Llun", "Gŵyl banc y gwanwyn"],
              ["5 Awst", "Dydd Llun", "Gŵyl banc yr haf"],
              ["2 Rhagfyr", "Dydd Llun", "Gŵyl Andreas (diwrnod amgen)"],
              ["25 Rhagfyr", "Dydd Mercher", "Dydd Nadolig"],
              ["26 Rhagfyr", "Dydd Iau", "Dydd San Steffan"],
            ])

            expect(page).to have_bank_holiday_table(title: "Gwyliau banc blaenorol yn yr Alban", year: "2012", rows: [
              ["Dyddiad", "Diwrnod yr wythnos", "Gŵyl y banc"],
              ["30 Tachwedd", "Dydd Gwener", "Gŵyl Andreas"],
              ["6 Awst", "Dydd Llun", "Gŵyl banc yr haf"],
              ["5 Mehefin", "Dydd Mawrth", "Jiwbilî Ddiemwnt y Frenhines (gŵyl banc ychwanegol)"],
              ["4 Mehefin", "Dydd Llun", "Gŵyl banc y gwanwyn (diwrnod amgen)"],
              ["7 Mai", "Dydd Llun", "Gŵyl banc dechrau Mai"],
              ["6 Ebrill", "Dydd Gwener", "Gwener y Groglith"],
              ["3 Ionawr", "Dydd Mawrth", "Dydd Calan (diwrnod amgen)"],
              ["2 Ionawr", "Dydd Llun", "2il o Ionawr"],
            ])
          end

          within("#gogledd-iwerddon") do
            expect(page).to have_link("Ychwanegu'r gwyliau banc ar gyfer Gogledd Iwerddon at eich calendr (ICS, 14KB)", href: "/gwyliau-banc/gogledd-iwerddon.ics")

            expect(page).to have_bank_holiday_table(title: "Gwyliau banc i ddod yng Ngogledd Iwerddon", year: "2012", rows: [
              ["Dyddiad", "Diwrnod yr wythnos", "Gŵyl y banc"],
              ["25 Rhagfyr", "Dydd Mawrth", "Dydd Nadolig"],
              ["26 Rhagfyr", "Dydd Mercher", "Dydd San Steffan"],
            ])

            expect(page).to have_bank_holiday_table(title: "Gwyliau banc i ddod yng Ngogledd Iwerddon", year: "2013", rows: [
              ["Dyddiad", "Diwrnod yr wythnos", "Gŵyl y banc"],
              ["1 Ionawr", "Dydd Mawrth", "Dydd Calan"],
              ["18 Mawrth", "Dydd Llun", "Gŵyl Sant Padrig (diwrnod amgen)"],
              ["29 Mawrth", "Dydd Gwener", "Gwener y Groglith"],
              ["1 Ebrill", "Dydd Llun", "Llun y Pasg"],
              ["6 Mai", "Dydd Llun", "Gŵyl banc dechrau Mai"],
              ["27 Mai", "Dydd Llun", "Gŵyl banc y gwanwyn"],
              ["12 Gorffennaf", "Dydd Gwener", "Brwydr y Boyne (Dydd yr Orenwyr)"],
              ["26 Awst", "Dydd Llun", "Gŵyl banc yr haf"],
              ["25 Rhagfyr", "Dydd Mercher", "Dydd Nadolig"],
              ["26 Rhagfyr", "Dydd Iau", "Dydd San Steffan"],
            ])

            expect(page).to have_bank_holiday_table(title: "Gwyliau banc blaenorol yng Ngogledd Iwerddon", year: "2012", rows: [
              ["Dyddiad", "Diwrnod yr wythnos", "Gŵyl y banc"],
              ["27 Awst", "Dydd Llun", "Gŵyl banc yr haf"],
              ["12 Gorffennaf", "Dydd Iau", "Brwydr y Boyne (Dydd yr Orenwyr)"],
              ["5 Mehefin", "Dydd Mawrth", "Jiwbilî Ddiemwnt y Frenhines (gŵyl banc ychwanegol)"],
              ["4 Mehefin", "Dydd Llun", "Gŵyl banc y gwanwyn"],
              ["7 Mai", "Dydd Llun", "Gŵyl banc dechrau Mai"],
              ["9 Ebrill", "Dydd Llun", "Llun y Pasg"],
              ["6 Ebrill", "Dydd Gwener", "Gwener y Groglith"],
              ["19 Mawrth", "Dydd Llun", "Gŵyl Sant Padrig (diwrnod amgen)"],
              ["2 Ionawr", "Dydd Llun", "Dydd Calan (diwrnod amgen)"],
            ])
          end
        end
      end
    end
  end

  it "displays the correct upcoming event" do
    Timecop.travel(Date.parse("2012-01-03")) do
      visit "/gwyliau-banc"

      within(".govuk-tabs") do
        within("#cymru-a-lloegr .govuk-panel") do
          expect(page).to have_content("Yr \u0175yl banc nesaf yng Nghymru a Lloegr yw")
          expect(page).to have_content("6 Ebrill")
          expect(page).to have_content("Gwener y Groglith")
        end

        within("#yr-alban .govuk-panel") do
          expect(page).to have_content("Yr \u0175yl banc nesaf yn yr Alban yw")
          expect(page).to have_content("heddiw")
          expect(page).to have_content("Dydd Calan")
        end

        within("#gogledd-iwerddon .govuk-panel") do
          expect(page).to have_content("Yr \u0175yl banc nesaf yng Ngogledd Iwerddon yw")
          expect(page).to have_content("19 Mawrth")
          expect(page).to have_content("G\u0175yl Sant Padrig")
        end
      end
    end
  end

  context "when showing bunting on bank holidays" do
    it "shows bunting when today is a buntable bank holiday" do
      Timecop.travel(Date.parse("2nd Jan 2012")) do
        visit "/gwyliau-banc"

        expect(page).to have_css(".app-bunting")
      end
    end

    it "does not show bunting if today is a non-buntable bank holiday" do
      Timecop.travel(Date.parse("12th July 2013")) do
        visit "/gwyliau-banc"

        expect(page).not_to have_css(".app-bunting")
      end
    end

    it "does not show bunting when today is not a bank holiday" do
      Timecop.travel(Date.parse("3rd Feb 2012")) do
        visit "/gwyliau-banc"

        expect(page).not_to have_css(".app-bunting")
      end
    end
  end

  describe "last updated" do
    it "is translated and localised" do
      Timecop.travel(Date.parse("25th Dec 2012")) do
        visit "/gwyliau-banc"

        within(".gem-c-metadata") do
          expect(page).to have_content("Diweddarwyd ddiwethaf 25 Rhagfyr 2012")
        end
      end
    end
  end
end
