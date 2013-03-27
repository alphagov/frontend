require_relative '../../test_helper'

class TravelAdviceIndexPresenterTest < ActiveSupport::TestCase

  context "handling countries" do
    setup do
      @json_data = File.read(Rails.root.join('test/fixtures/foreign-travel-advice/index1.json'))
      @artefact = GdsApi::Response.new(stub("HTTP_Response", :code => 200, :body => @json_data))
      @presenter = TravelAdviceIndexPresenter.new(@artefact)
    end

    context "countries" do
      should "return the countries in the same order as in the JSON" do
        assert_equal 6, @presenter.countries.length
        assert_equal ["Aruba", "Congo", "Germany", "Iran", "Portugal", "Turks and Caicos Islands"], @presenter.countries.map {|c| c.name }
      end
    end

    context "countries_by_date" do
      should "return countries ordered by last_updated most recent first" do
        assert_equal 6, @presenter.countries_by_date.length
        assert_equal ["Portugal", "Aruba", "Turks and Caicos Islands", "Congo", "Germany", "Iran"], @presenter.countries_by_date.map {|c| c.name }
      end

      should "memoize the result" do
        first = @presenter.countries_by_date
        @presenter.expects(:countries).never
        assert_equal first, @presenter.countries_by_date
      end
    end

    context "countries_recently_updated" do
      should "return the 5 most recently updated countries" do
        assert_equal 5, @presenter.countries_recently_updated.length
        assert_equal ["Portugal", "Aruba", "Turks and Caicos Islands", "Congo", "Germany"], @presenter.countries_recently_updated.map {|c| c.name }
      end
    end
  end
end
