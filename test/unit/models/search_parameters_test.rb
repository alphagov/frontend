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
  end

  context '#start' do
    should 'start at 0 if start < 1' do
      params = SearchParameters.new(start: -1)

      assert_equal 0, params.start
    end
  end
end
