require "integration_test_helper"

class TravelAdviceAtomTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::ContentStore

  context "aggregate feed" do
    should "display the list of countries as an atom feed" do
      content_item = GovukSchemas::Example.find("travel_advice_index", example_name: "index")
      base_path = content_item.fetch("base_path")
      stub_content_store_has_item(base_path, content_item)

      visit "/foreign-travel-advice.atom"
      assert_equal 200, page.status_code

      assert page.has_xpath? ".//feed/id", text: "http://www.example.com/foreign-travel-advice"
      assert page.has_xpath? ".//feed/title", text: "Travel Advice Summary"

      assert page.has_xpath? ".//feed/link[@rel='self' and @href='http://www.example.com/foreign-travel-advice.atom']"
      assert page.has_xpath? ".//feed/link[@rel='alternate' and @type='text/html' and @href='http://www.example.com/foreign-travel-advice']"

      assert page.has_xpath? ".//feed/updated", text: "2015-12-08T17:02:23+00:00"
      assert page.has_xpath? ".//feed/entry", count: 7

      assert page.has_xpath? ".//feed/entry[1]/title", text: "São Tomé and Principe"
      assert page.has_xpath? ".//feed/entry[1]/id", text: "https://www.gov.uk/foreign-travel-advice/sao-tome-and-principe#2015-12-08T17:02:23+00:00"
      assert page.has_xpath? ".//feed/entry[1]/link[@type='text/html' and @href='https://www.gov.uk/foreign-travel-advice/sao-tome-and-principe']"
      assert page.has_xpath? ".//feed/entry[1]/link[@type='application/atom+xml' and @href='https://www.gov.uk/foreign-travel-advice/sao-tome-and-principe.atom']"
      assert page.has_xpath? ".//feed/entry[1]/updated", text: "2015-12-08T17:02:23+00:00"
      assert page.has_xpath? ".//feed/entry[1]/summary[@type='xhtml']/div/p", text: "Latest update: Entry requirements section - British nationals don’t need a visa to visit Sao Tome and Principe for up to 15 days; for longer stays, you should get a visa before you travel"

      assert page.has_xpath? ".//feed/entry[2]/title", text: "Spain"
      assert page.has_xpath? ".//feed/entry[2]/id", text: "https://www.gov.uk/foreign-travel-advice/spain#2015-01-06T00:00:00+00:00"
      assert page.has_xpath? ".//feed/entry[2]/link[@type='text/html' and @href='https://www.gov.uk/foreign-travel-advice/spain']"
      assert page.has_xpath? ".//feed/entry[2]/link[@type='application/atom+xml' and @href='https://www.gov.uk/foreign-travel-advice/spain.atom']"
      assert page.has_xpath? ".//feed/entry[2]/updated", text: "2015-01-06T00:00:00+00:00"
      assert page.has_xpath? ".//feed/entry[2]/summary[@type='xhtml']/div/p", text: "Latest update: Summary – information and advice for Manchester City fans travelling to Seville"
    end

    should "render a maximum of 20 countries" do
      content_item = GovukSchemas::Example.find("travel_advice_index", example_name: "index")
      content_item["links"]["children"] = content_item["links"]["children"] * 5
      base_path = content_item.fetch("base_path")
      stub_content_store_has_item(base_path, content_item)

      visit "/foreign-travel-advice.atom"
      assert_equal 200, page.status_code
      assert page.has_xpath? ".//feed/entry", count: 20
    end
  end
end
