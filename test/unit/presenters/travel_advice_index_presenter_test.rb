require 'test_helper'

class TravelAdviceIndexPresenterTest < ActiveSupport::TestCase
  context "handling countries" do
    setup do
      json = GovukContentSchemaTestHelpers::Examples.new.get('travel_advice_index', 'index')
      attributes = JSON.parse(json)
      @presenter = TravelAdviceIndexPresenter.new(attributes)
    end

    should "set the index attributes correctly" do
      assert_equal "https://public.govdelivery.com/accounts/UKGOVUK/subscriber/topics?qsp=TRAVEL", @presenter.subscription_url
      assert_equal "Latest travel advice by country including safety and security, entry requirements, travel warnings and health", @presenter.description
      assert_equal "foreign-travel-advice", @presenter.slug
      assert_equal "Foreign travel advice", @presenter.title
    end

    should "set the country attributes correctly" do
      country = @presenter.countries.first

      assert_equal "Latest update: Summary - on 26 October 2015 a serious earthquake struck causing casualties around the country and affecting communications networks; if someone you know is likely to have been involved and you're unable to contact them, contact the British Embassy in Kabul", country.change_description
      assert_equal "Afghanistan", country.name
      assert_equal "Afghanistan", country.title
      assert_equal [], country.synonyms
      assert_equal "http://www.dev.gov.uk/foreign-travel-advice/afghanistan", country.web_url
      assert_equal "afghanistan", country.identifier
      assert_equal DateTime.new(2015, 1, 1), country.updated_at
    end

    context "#countries" do
      should "return the countries in the same order as in the JSON" do
        names = @presenter.countries.map(&:name)
        assert_equal %w(Afghanistan Austria Finland India Malaysia Spain), names
      end
    end

    context "#countries_by_date" do
      should "return the countries, ordered by updated_at descending" do
        names = @presenter.countries_by_date.map(&:name)
        assert_equal %w(Spain Malaysia India Finland Austria Afghanistan), names
      end
    end

    context "#countries_recently_updated" do
      should "return the 5 most recently updated countries" do
        names = @presenter.countries_recently_updated.map(&:name)
        assert_equal %w(Spain Malaysia India Finland Austria), names
      end
    end
  end
end
