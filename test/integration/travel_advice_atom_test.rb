require 'integration_test_helper'
require "gds_api/test_helpers/content_store"

class TravelAdviceAtomTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::ContentStore

  context "on a single country page" do
    should "display the atom feed for a country" do
      setup_api_responses "foreign-travel-advice/luxembourg"
      visit "/foreign-travel-advice/luxembourg.atom"

      assert_equal 200, page.status_code

      assert page.has_xpath? ".//feed/id", text: "https://www.gov.uk/foreign-travel-advice/luxembourg"
      assert page.has_xpath? ".//feed/title", text: "Travel Advice Summary"
      assert page.has_xpath? ".//feed/link[@rel='self' and @href='http://www.example.com/foreign-travel-advice/luxembourg.atom']"
      assert page.has_xpath? ".//feed/entry", count: 1
      assert page.has_xpath? ".//feed/entry/title", text: "Luxembourg"
      assert page.has_xpath? ".//feed/entry/id", text: "https://www.gov.uk/foreign-travel-advice/luxembourg#2013-01-31T11:35:17+00:00"
      assert page.has_xpath? ".//feed/entry/link[@href='https://www.gov.uk/foreign-travel-advice/luxembourg']"
      assert page.has_xpath? ".//feed/entry/summary[@type='xhtml']/div/p", text: "The issue with the Knights of Ni has been resolved."
    end

    should "handle special chars in a way that's valid in xml" do
      setup_api_responses "foreign-travel-advice/afghanistan"

      visit "/foreign-travel-advice/afghanistan.atom"

      assert_equal 200, page.status_code

      assert page.has_xpath? ".//feed/entry", count: 1
      assert page.has_xpath? ".//feed/entry/title", text: "Afghanistan"

      assert_match /Travel advicé for "Afghanistan" has been updated &amp; is better\. “GOV\.UK”/, page.body
    end
  end

  context "aggregate feed" do
    should "display the list of countries as an atom feed" do
      json = GovukContentSchemaTestHelpers::Examples.new.get('travel_advice_index', 'index')
      content_item = JSON.parse(json)
      base_path = content_item.fetch("base_path")
      content_store_has_item(base_path, content_item)

      visit '/foreign-travel-advice.atom'
      assert_equal 200, page.status_code

      assert page.has_xpath? ".//feed/id", text: "http://www.example.com/foreign-travel-advice"
      assert page.has_xpath? ".//feed/title", text: "Travel Advice Summary"

      assert page.has_xpath? ".//feed/link[@rel='self' and @href='http://www.example.com/foreign-travel-advice.atom']"
      assert page.has_xpath? ".//feed/link[@rel='alternate' and @type='text/html' and @href='http://www.example.com/foreign-travel-advice']"
      assert page.has_xpath? ".//feed/updated", text: "2015-01-06T00:00:00+00:00"
      assert page.has_xpath? ".//feed/entry", count: 6

      assert page.has_xpath? ".//feed/entry[1]/title", text: "Spain"
      assert page.has_xpath? ".//feed/entry[1]/id", text: "https://www.gov.uk/foreign-travel-advice/spain#2015-01-06T00:00:00+00:00"
      assert page.has_xpath? ".//feed/entry[1]/link[@type='text/html' and @href='https://www.gov.uk/foreign-travel-advice/spain']"
      assert page.has_xpath? ".//feed/entry[1]/link[@type='application/atom+xml' and @href='https://www.gov.uk/foreign-travel-advice/spain.atom']"
      assert page.has_xpath? ".//feed/entry[1]/updated", text: "2015-01-06T00:00:00+00:00"
      assert page.has_xpath? ".//feed/entry[1]/summary[@type='xhtml']/div/p", text: "Latest update: Summary – information and advice for Manchester City fans travelling to Seville"

      assert page.has_xpath? ".//feed/entry[2]/title", text: "Malaysia"
      assert page.has_xpath? ".//feed/entry[2]/id", text: "https://www.gov.uk/foreign-travel-advice/malaysia#2015-01-05T00:00:00+00:00"
      assert page.has_xpath? ".//feed/entry[2]/link[@type='text/html' and @href='https://www.gov.uk/foreign-travel-advice/malaysia']"
      assert page.has_xpath? ".//feed/entry[2]/link[@type='application/atom+xml' and @href='https://www.gov.uk/foreign-travel-advice/malaysia.atom']"
      assert page.has_xpath? ".//feed/entry[2]/updated", text: "2015-01-05T00:00:00+00:00"
      assert page.has_xpath? ".//feed/entry[2]/summary[@type='xhtml']/div/p", text: "Latest update: Summary - haze can cause disruption to local, regional air travel and to government and private schools"
    end

    should "render a maximum of 20 countries" do
      json = GovukContentSchemaTestHelpers::Examples.new.get('travel_advice_index', 'index')
      content_item = JSON.parse(json)
      content_item["details"]["countries"] = content_item["details"]["countries"] * 5
      base_path = content_item.fetch("base_path")
      content_store_has_item(base_path, content_item)

      visit '/foreign-travel-advice.atom'
      assert_equal 200, page.status_code
      assert page.has_xpath? ".//feed/entry", count: 20
    end
  end
end
