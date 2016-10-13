# coding: utf-8
require "test_helper"

class SearchResultTest < ActiveSupport::TestCase
  should "report when no examples are present" do
    result = SearchResult.new(SearchParameters.new({}), {}).to_hash
    assert_equal false, result[:examples_present?]
  end

  should "present examples" do
    result = SearchResult.new(SearchParameters.new({}),
                              "examples" => [{ "title" => "An example" }]).to_hash
    assert_equal true, result[:examples_present?]
    assert_equal [{ "title" => "An example" }], result[:examples]
  end
end
