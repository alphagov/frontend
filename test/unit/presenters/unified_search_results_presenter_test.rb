require_relative "../../test_helper"

class UnifiedSearchResultsPresenterTest < ActiveSupport::TestCase
  should "return an appropriate hash" do
    results = UnifiedSearchResultsPresenter.new({
      "total" => 1,
      "results" => [ { "index" => "mainstream" } ],
      "facets" => []
    }, 'my-query', {})
    assert_equal 'my-query', results.to_hash[:query]
    assert_equal 1, results.to_hash[:result_count]
    assert_equal '1 result', results.to_hash[:result_count_string]
    assert_equal true, results.to_hash[:results_any?]
  end

  should "return an entry for a facet" do
    results = UnifiedSearchResultsPresenter.new({
      "results" => [],
      "facets" => {
        "organisations" => {
          "options" => [ {
            "value" => {
              "link" => "/government/organisations/department-for-education",
              "title" => "Department for Education"
            },
            "documents" => 114
          } ]
        }
      }
    }, 'my-query', {})

    assert results.to_hash[:filter_fields]["organisations"]
    assert_equal 1, results.to_hash[:filter_fields]["organisations"][:options].length
    assert_equal "Department for Education", results.to_hash[:filter_fields]["organisations"][:options][0][:title]
  end
end
