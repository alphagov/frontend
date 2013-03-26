require_relative '../integration_test_helper'

class TravelAdviceAtomTest < ActionDispatch::IntegrationTest

  context "on a single country page" do
    should "display the atom feed for a country" do
      setup_api_responses "foreign-travel-advice/luxembourg"
      visit "/foreign-travel-advice/luxembourg.atom"

      assert_equal 200, page.status_code

      assert page.has_xpath? ".//feed/title", :text => "Travel Advice Summary"
      assert page.has_xpath? ".//feed/link[@rel='self' and @href='http://www.example.com/foreign-travel-advice/luxembourg.atom']"
      assert page.has_xpath? ".//feed/entry", :count => 1
      assert page.has_xpath? ".//feed/entry/title", :text => "Luxembourg"
      assert page.has_xpath? ".//feed/entry/id", :text => "https://www.gov.uk/foreign-travel-advice/luxembourg#2013-01-31T11:35:17+00:00"
      assert page.has_xpath? ".//feed/entry/link[@href='https://www.gov.uk/foreign-travel-advice/luxembourg']"
      assert page.has_xpath? ".//feed/entry/summary[@type='xhtml']/div/p", :text => "The issue with the Knights of Ni has been resolved."
    end

    should "handle xhtml entities in a way that's valid in xml" do
      setup_api_responses "foreign-travel-advice/afghanistan"

      visit "/foreign-travel-advice/afghanistan.atom"

      assert_equal 200, page.status_code

      assert page.has_xpath? ".//feed/entry", :count => 1
      assert page.has_xpath? ".//feed/entry/title", :text => "Afghanistan"

      # 8220 and 8221 are the decimal versions of smart-quotes (&ldquo; and &rdquo;)
      assert_match /Travel advice for Afghanistan has been updated\. &#8220;GOV\.UK&#8221;/, page.body
    end
  end

  context "aggregate feed" do
    should "display the list of countries as an atom feed" do
      setup_api_responses("foreign-travel-advice", :file => 'foreign-travel-advice/index2.json')

      visit '/foreign-travel-advice.atom'
      assert_equal 200, page.status_code

      assert page.has_xpath? ".//feed/title", :text => "Travel Advice Summary"

      assert page.has_xpath? ".//feed/link[@rel='self' and @href='http://www.example.com/foreign-travel-advice.atom']"
      assert page.has_xpath? ".//feed/link[@rel='alternate' and @type='text/html' and @href='http://www.example.com/foreign-travel-advice']"
      assert page.has_xpath? ".//feed/updated", :text => "2013-02-23T11:31:08+00:00"
      assert page.has_xpath? ".//feed/entry", :count => 3

      assert page.has_xpath? ".//feed/entry[1]/title", :text => "Syria"
      assert page.has_xpath? ".//feed/entry[1]/id", :text => "https://www.gov.uk/foreign-travel-advice/syria#2013-02-23T11:31:08+00:00"
      assert page.has_xpath? ".//feed/entry[1]/link[@type='text/html' and @href='https://www.gov.uk/foreign-travel-advice/syria']"
      assert page.has_xpath? ".//feed/entry[1]/link[@type='application/atom+xml' and @href='https://www.gov.uk/foreign-travel-advice/syria.atom']"
      assert page.has_xpath? ".//feed/entry[1]/updated", :text => "2013-02-23T11:31:08+00:00"
      assert page.has_xpath? ".//feed/entry[1]/summary[@type='xhtml']/div/div[@class='application-notice help-notice']/p", :text => "Serious problems in the country."

      assert page.has_xpath? ".//feed/entry[2]/title", :text => "Luxembourg"
      assert page.has_xpath? ".//feed/entry[2]/id", :text => "https://www.gov.uk/foreign-travel-advice/luxembourg#2013-01-15T16:48:54+00:00"
      assert page.has_xpath? ".//feed/entry[2]/link[@type='text/html' and @href='https://www.gov.uk/foreign-travel-advice/luxembourg']"
      assert page.has_xpath? ".//feed/entry[2]/link[@type='application/atom+xml' and @href='https://www.gov.uk/foreign-travel-advice/luxembourg.atom']"
      assert page.has_xpath? ".//feed/entry[2]/updated", :text => "2013-01-15T16:48:54+00:00"
      assert page.has_xpath? ".//feed/entry[2]/summary[@type='xhtml']/div/p", :text => "The issue with the Knights of Ni has been resolved."

      assert page.has_xpath? ".//feed/entry[3]/title", :text => "Portugal"
      assert page.has_xpath? ".//feed/entry[3]/id", :text => "https://www.gov.uk/foreign-travel-advice/portugal#2012-02-22T11:31:08+00:00"
      assert page.has_xpath? ".//feed/entry[3]/link[@type='text/html' and @href='https://www.gov.uk/foreign-travel-advice/portugal']"
      assert page.has_xpath? ".//feed/entry[3]/link[@type='application/atom+xml' and @href='https://www.gov.uk/foreign-travel-advice/portugal.atom']"
      assert page.has_xpath? ".//feed/entry[3]/updated", :text => "2012-02-22T11:31:08+00:00"
      assert page.has_xpath? ".//feed/entry[3]/summary[@type='xhtml']/div/p", :text => "Added information about sunburn risks."
    end

    should "only include the 20 most recently updated countries" do
      setup_api_responses("foreign-travel-advice", :file => 'foreign-travel-advice/index_large.json')

      visit '/foreign-travel-advice.atom'
      assert_equal 200, page.status_code

      assert page.has_xpath? ".//feed/title", :text => "Travel Advice Summary"

      assert page.has_xpath? ".//feed/entry", :count => 20

      assert page.has_xpath? ".//feed/entry[1]/title", :text => "First"
      assert page.has_xpath? ".//feed/entry[20]/title", :text => "Twentieth"
    end
  end
end
