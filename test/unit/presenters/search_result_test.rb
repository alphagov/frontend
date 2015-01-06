require_relative "../../test_helper"

class SearchResultTest < ActiveSupport::TestCase
  should "display a description" do
    result = SearchResult.new(SearchParameters.new({}), "description" => "I like pie")
    assert_equal "I like pie", result.description
  end

  should "display a generic description for topics which are missing them" do
    result = SearchResult.new(SearchParameters.new({}), "format" => "specialist_sector", "title" => "VAT")
    assert_equal "List of information about VAT", result.description
  end

  should "not display a generic description for other formats which are missing them" do
    result = SearchResult.new(SearchParameters.new({}), "format" => "edition", "title" => "VAT")
    assert_nil result.description
  end
end
