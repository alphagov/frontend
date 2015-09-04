require "test_helper"

class SearchParameterTest < ActiveSupport::TestCase
  context '#count' do
    should 'default to default page size' do
      params = SearchParameters.new({})

      assert_equal SearchParameters::DEFAULT_RESULTS_PER_PAGE, params.count
    end

    should 'default to default page size when count < 1' do
      params = SearchParameters.new(count: -50)

      assert_equal SearchParameters::DEFAULT_RESULTS_PER_PAGE, params.count
    end

    should 'allow at most a hundred results' do
      params = SearchParameters.new(count: 10_000)

      assert_equal 100, params.count
    end
  end

  context '#start' do
    should 'start at 0 if start < 1' do
      params = SearchParameters.new(start: -1)

      assert_equal 0, params.start
    end
  end

  context "#filter_organisations" do
    should "pass on filter_organisations" do
      params = SearchParameters.new("filter_organisations" => ['ministry-of-silly-walks'])

      assert_equal ['ministry-of-silly-walks'], params.rummager_parameters[:filter_organisations]
    end

    should "pass on filter_organisations as an array if provided as single value" do
      params = SearchParameters.new("filter_organisations" => 'ministry-of-silly-walks')

      assert_equal ['ministry-of-silly-walks'], params.rummager_parameters[:filter_organisations]
    end
  end

  context "#filter_topics" do
    should "translates the key for the specialist sector facet" do
      params = SearchParameters.new("filter_topics" => ['a-topic'])

      assert_equal ['a-topic'], params.rummager_parameters[:filter_specialist_sectors]
    end
  end
end
