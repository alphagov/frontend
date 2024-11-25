RSpec.describe "TravelAdviceAtom" do
  include GdsApi::TestHelpers::ContentStore

  context "aggregate feed" do
    it "displays the list of countries as an atom feed" do
      content_item = GovukSchemas::Example.find("travel_advice_index", example_name: "index")
      base_path = content_item.fetch("base_path")
      stub_content_store_has_item(base_path, content_item)
      visit "/foreign-travel-advice.atom"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(".//feed/id", text: "http://www.example.com/foreign-travel-advice")
      expect(page).to have_xpath(".//feed/title", text: "Travel Advice Summary")
      expect(page).to have_xpath(".//feed/link[@rel='self' and @href='http://www.example.com/foreign-travel-advice.atom']")
      expect(page).to have_xpath(".//feed/link[@rel='alternate' and @type='text/html' and @href='http://www.example.com/foreign-travel-advice']")
      expect(page).to have_xpath(".//feed/updated", text: "2015-12-08T17:02:23+00:00")
      expect(page).to have_xpath(".//feed/entry", count: 7)
      expect(page).to have_xpath(".//feed/entry[1]/title", text: "S\u00E3o Tom\u00E9 and Principe")
      expect(page).to have_xpath(".//feed/entry[1]/id", text: "http://www.dev.gov.uk/foreign-travel-advice/sao-tome-and-principe#2015-12-08T17:02:23+00:00")
      expect(page).to have_xpath(".//feed/entry[1]/link[@type='text/html' and @href='http://www.dev.gov.uk/foreign-travel-advice/sao-tome-and-principe']")
      expect(page).to have_xpath(".//feed/entry[1]/link[@type='application/atom+xml' and @href='http://www.dev.gov.uk/foreign-travel-advice/sao-tome-and-principe.atom']")
      expect(page).to have_xpath(".//feed/entry[1]/updated", text: "2015-12-08T17:02:23+00:00")
      expect(page).to have_xpath(".//feed/entry[1]/summary[@type='xhtml']/div/p", text: "Latest update: Entry requirements section - British nationals don\u2019t need a visa to visit Sao Tome and Principe for up to 15 days; for longer stays, you should get a visa before you travel")
      expect(page).to have_xpath(".//feed/entry[2]/title", text: "Spain")
      expect(page).to have_xpath(".//feed/entry[2]/id", text: "http://www.dev.gov.uk/foreign-travel-advice/spain#2015-01-06T00:00:00+00:00")
      expect(page).to have_xpath(".//feed/entry[2]/link[@type='text/html' and @href='http://www.dev.gov.uk/foreign-travel-advice/spain']")
      expect(page).to have_xpath(".//feed/entry[2]/link[@type='application/atom+xml' and @href='http://www.dev.gov.uk/foreign-travel-advice/spain.atom']")
      expect(page).to have_xpath(".//feed/entry[2]/updated", text: "2015-01-06T00:00:00+00:00")
      expect(page).to have_xpath(".//feed/entry[2]/summary[@type='xhtml']/div/p", text: "Latest update: Summary \u2013 information and advice for Manchester City fans travelling to Seville")
    end

    it "renders a maximum of 20 countries" do
      content_item = GovukSchemas::Example.find("travel_advice_index", example_name: "index")
      content_item["links"]["children"] = (content_item["links"]["children"] * 5)
      base_path = content_item.fetch("base_path")
      stub_content_store_has_item(base_path, content_item)
      visit "/foreign-travel-advice.atom"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(".//feed/entry", count: 20)
    end
  end

  context "individual country feed" do
    it "displays a country as an atom feed" do
      content_store_response = GovukSchemas::Example.find("travel_advice", example_name: "full-country")
      base_path = content_store_response.fetch("base_path")
      stub_content_store_has_item(base_path, content_store_response)

      visit "#{base_path}.atom"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(".//feed/id", text: "http://www.dev.gov.uk#{base_path}")
      expect(page).to have_xpath(".//feed/title", text: "Travel Advice Summary")
      expect(page).to have_xpath(".//feed/updated", text: "2017-02-14T15:42:21+00:00")
      expect(page).to have_xpath(".//feed/link[@rel='self' and @href='http://www.example.com#{base_path}.atom']")
      expect(page).to have_xpath(".//feed/link[@rel='alternate' and @type='text/html' and @href='http://www.dev.gov.uk#{base_path}']")
      expect(page).to have_xpath(".//feed/author/name", text: "GOV.UK")
      expect(page).to have_xpath(".//feed/entry", count: 1)
      expect(page).to have_xpath(".//feed/entry[1]/id", text: "http://www.dev.gov.uk#{base_path}##{Time.zone.parse(content_store_response['public_updated_at'])}")
      expect(page).to have_xpath(".//feed/entry[1]/title", text: (content_store_response["title"]).to_s)
      expect(page).to have_xpath(".//feed/entry[1]/updated", text: "2017-02-14T15:42:21+00:00")
      expect(page).to have_xpath(".//feed/entry[1]/link[@type='text/html' and @href='http://www.dev.gov.uk#{base_path}']")
      expect(page).to have_xpath(".//feed/entry[1]/link[@type='application/atom+xml' and @href='http://www.dev.gov.uk#{base_path}.atom']")
      expect(page).to have_xpath(".//feed/entry[1]/summary[@type='xhtml']/div/p", text: (content_store_response["change_description"]).to_s)
    end
  end
end
