RSpec.describe "DetailedGuide" do
  include SchemaOrgHelpers
  include SinglePageNotificationHelpers

  let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide") }
  let(:base_path) { content_store_response.fetch("base_path") }

  before do
    stub_content_store_has_item(base_path, content_store_response)
    visit base_path
  end

  it_behaves_like "it has meta tags", "detailed_guide", "detailed_guide"
  it_behaves_like "it has meta tags for images", "detailed_guide", "detailed_guide"

  context "when visiting a detailed guide page" do
    it "displays the guidance page" do
      expect(page).to have_title(content_store_response["title"])
      expect(page).to have_css("h1", text: "Salary sacrifice")
      expect(page).to have_text(content_store_response["description"])
    end

    it "renders the relevant metadata" do
      within("[class*='metadata-column']") do
        expect(page).to have_text("From: HM Revenue & Customs")
        expect(page).to have_link("HM Revenue & Customs", href: "/government/organisations/hm-revenue-customs")
        expect(page).to have_text("Published 12 June 2014")
        expect(page).to have_text("Last updated 18 February 2016")
      end
    end

    it "renders back to contents elements" do
      expect(page).to have_css(".gem-c-back-to-top-link[href='#contents']")
    end

    it "renders a contents list" do
      expect(page).to have_css(".gem-c-contents-list")
    end

    it "renders FAQ structured data" do
      faq_schema = find_schema_of_type("FAQPage")

      expect(faq_schema["name"]).to eq(content_store_response["title"])
      expect(faq_schema["mainEntity"]).not_to eq([])
    end
  end

  context "when visiting a withdrawn detailed guide page" do
    let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "withdrawn_detailed_guide") }

    it "displays withdrawn detailed guide page" do
      expect(page).to have_title("[Withdrawn] EU rules on the use of chemicals - GOV.UK")
      expect(page).to have_css(".govspeak", text: "This information has been archived as it is now out of date. For current information please go to")
      expect(page).to have_content("withdrawn on 28 January 2015")
    end
  end

  context "when visiting a historically political detailed guide page" do
    let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "political_detailed_guide") }

    it "displays historically political detailed guide page" do
      within(".govuk-notification-banner__content") do
        expect(page).to have_content("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
      end
    end
  end

  context "when visiting detailed guide that applies to a set of nations only" do
    let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "national_applicability_detailed_guide") }

    it "displays detailed guide page that applies to a set of nations" do
      expect(page).to have_devolved_nations_component("Applies to England")
    end
  end

  context "when visiting detailed guide that applies to a set of nations with alternative URLs" do
    let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "national_applicability_alternative_url_detailed_guide") }

    it "displays detailed guide page that applies to a set of nations having alternative URLs" do
      expect(page).to have_devolved_nations_component("Applies to England, Scotland and Wales", [
        {
          text: "Guidance for Northern Ireland",
          alternative_url: "http://www.dardni.gov.uk/news-dard-pa022-a-13-new-procedure-for",
        },
      ])
    end
  end

  context "when visiting a translated detailed guide page" do
    let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "translated_detailed_guide") }

    it "displays available translations for detailed guide page" do
      within(".gem-c-translation-nav") do
        expect(page).to have_css(".gem-c-translation-nav__list-item", text: "English")
        expect(page).to have_link("Cymraeg", href: "/guidance/prepare-a-charity-annual-return.cy")
      end
    end
  end

  context "when visiting a detailed guide page with logo" do
    let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "england-2014-to-2020-european-structural-and-investment-funds") }

    it "conditionally renders a logo" do
      expect(page).to have_css(".metadata-logo[alt='European structural investment funds']")
    end
  end

  context "when checking for single page notification button" do
    it "renders with the single page notification button on English language pages" do
      expect(page).to have_css(".gem-c-single-page-notification-button")

      buttons = page.all("button[data-ga4-link]")
      expected_tracking_top = single_page_notification_button_ga4_tracking(1, "Top")
      actual_tracking_top = JSON.parse(buttons.first["data-ga4-link"])

      expect(actual_tracking_top).to eq(expected_tracking_top)

      expected_tracking_bottom = single_page_notification_button_ga4_tracking(2, "Footer")
      actual_tracking_bottom = JSON.parse(buttons.last["data-ga4-link"])

      expect(actual_tracking_bottom).to eq(expected_tracking_bottom)
    end

    it "does not render the single page notification button on exempt pages" do
      content_store_response["content_id"] = "c5c8d3cd-0dc2-4ca3-8672-8ca0a6e92165"
      stub_content_store_has_item("/guidance/salary-sacrifice-and-the-effects-on-paye", content_store_response)

      visit "/guidance/salary-sacrifice-and-the-effects-on-paye"

      expect(page).not_to have_css(".gem-c-single-page-notification-button")
    end

    it "does not render the single page notification button on foreign language pages" do
      content_store_response["locale"] = "cy"
      stub_content_store_has_item("/guidance/salary-sacrifice-and-the-effects-on-paye", content_store_response)
      visit "/guidance/salary-sacrifice-and-the-effects-on-paye"

      expect(page).not_to have_css(".gem-c-single-page-notification-button")
    end
  end
end
