require_relative '../integration_test_helper'

class TravelAdviceAtomTest < ActionDispatch::IntegrationTest

  context "on a single country page" do
    setup do
      setup_api_responses "foreign-travel-advice/luxembourg"
    end

    should "display the atom feed for a country" do
      visit "/foreign-travel-advice/luxembourg.atom"

      assert_equal 200, page.status_code

      assert page.has_xpath? ".//feed/title", :text => "Travel Advice Summary"
      assert page.has_xpath? ".//feed/link[@rel='self' and @href='http://www.example.com/foreign-travel-advice/luxembourg.atom']"
      assert page.has_xpath? ".//feed/entry/title", :text => "Luxembourg"
      assert page.has_xpath? ".//feed/entry/link[@href='https://www.gov.uk/foreign-travel-advice/luxembourg']"
      assert page.has_xpath? ".//feed/entry/summary", :text => "There are no parts of Luxembourg that the FCO recommends avoiding."
    end
  end

  context "aggregate feed" do
    setup do
      setup_api_responses("foreign-travel-advice", :file => 'foreign-travel-advice/index2.json')
    end

    should "display the list of countries as an atom feed" do
      visit '/foreign-travel-advice.atom'
      assert_equal 200, page.status_code

      assert page.has_xpath? ".//feed/title", :text => "Travel Advice Summary"

      assert page.has_xpath? ".//feed/link[@rel='self' and @href='http://www.example.com/foreign-travel-advice.atom']"
      assert page.has_xpath? ".//feed/updated", :text => "2013-02-23T11:31:08+00:00"
      assert page.has_xpath? ".//feed/entry", :count => 3

      assert page.has_xpath? ".//feed/entry[1]/title", :text => "Syria"
      assert page.has_xpath? ".//feed/entry[1]/link[@type='text/html' and @href='https://www.gov.uk/foreign-travel-advice/syria']"
      assert page.has_xpath? ".//feed/entry[1]/link[@type='application/atom+xml' and @href='https://www.gov.uk/foreign-travel-advice/syria.atom']"
      assert page.has_xpath? ".//feed/entry[1]/updated", :text => "2013-02-23T11:31:08+00:00"

      assert page.has_xpath? ".//feed/entry[2]/title", :text => "Luxembourg"
      assert page.has_xpath? ".//feed/entry[2]/link[@type='text/html' and @href='https://www.gov.uk/foreign-travel-advice/luxembourg']"
      assert page.has_xpath? ".//feed/entry[2]/link[@type='application/atom+xml' and @href='https://www.gov.uk/foreign-travel-advice/luxembourg.atom']"
      assert page.has_xpath? ".//feed/entry[2]/updated", :text => "2013-01-15T16:48:54+00:00"

      assert page.has_xpath? ".//feed/entry[3]/title", :text => "Portugal"
      assert page.has_xpath? ".//feed/entry[3]/link[@type='text/html' and @href='https://www.gov.uk/foreign-travel-advice/portugal']"
      assert page.has_xpath? ".//feed/entry[3]/link[@type='application/atom+xml' and @href='https://www.gov.uk/foreign-travel-advice/portugal.atom']"
      assert page.has_xpath? ".//feed/entry[3]/updated", :text => "2012-02-22T11:31:08+00:00"
    end
  end
end
