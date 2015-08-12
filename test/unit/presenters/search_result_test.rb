# coding: utf-8
require_relative "../../test_helper"

class SearchResultTest < ActiveSupport::TestCase
  should "report when no examples are present" do
    result = SearchResult.new(SearchParameters.new({}), "description" => "I like pie").to_hash
    assert_equal false, result[:examples_present?]
  end

  should "present examples" do
    result = SearchResult.new(SearchParameters.new({}),
                              "examples" => [{"title" => "An example"}]).to_hash
    assert_equal true, result[:examples_present?]
    assert_equal [{"title" => "An example"}], result[:examples]
  end

  should "present suggested filters, using external field names" do
    result = SearchResult.new(SearchParameters.new({}),
      "suggested_filter" => {
        "field" => "specialist_sectors",
        "value" => "business-tax/vat",
        "count" => 42,
        "name" => "VAT",
      }).to_hash
    assert_equal false, result[:examples_present?]
    assert_equal true, result[:suggested_filter_present?]
    assert_equal "/search?filter_topics=business-tax%2Fvat", result[:suggested_filter_link]
    assert_equal %{All 42 results in "VAT"}, result[:suggested_filter_title]
  end
end
