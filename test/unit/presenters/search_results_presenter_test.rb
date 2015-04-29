require_relative "../../test_helper"

class SearchResultsPresenterTest < ActiveSupport::TestCase
  should "return an appropriate hash" do
    results = SearchResultsPresenter.new({
      "total" => 1,
      "results" => [ { "index" => "mainstream" } ],
      "facets" => {}
    }, SearchParameters.new({q: 'my-query'}))

    assert_equal 'my-query', results.to_hash[:query]
    assert_equal 1, results.to_hash[:result_count]
    assert_equal '1 result', results.to_hash[:result_count_string]
    assert_equal true, results.to_hash[:results_any?]
  end

  should "return an entry for a facet" do
    results = SearchResultsPresenter.new({
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
    }, SearchParameters.new({q: 'my-query'}))

    assert_equal 1, results.to_hash[:filter_fields].length
    assert_equal "organisations", results.to_hash[:filter_fields][0][:field]
    assert_equal "Organisations", results.to_hash[:filter_fields][0][:field_title]
    assert_equal 1, results.to_hash[:filter_fields][0][:options][:options].length
    assert_equal "Department for Education", results.to_hash[:filter_fields][0][:options][:options][0][:title]
  end

  should "map specialist_sector field in return facets to topics" do
    results = SearchResultsPresenter.new({
      "results" => [],
      "facets" => {
        "specialist_sectors" => {
          "options" => [ {
            "value" => {
              "link" => "/business-tax/vat",
              "title" => "VAT"
            },
            "documents" => 114
          } ]
        }
      }
    }, SearchParameters.new({q: 'my-query'}))

    assert_equal 1, results.to_hash[:filter_fields].length
    assert_equal "topics", results.to_hash[:filter_fields][0][:field]
    assert_equal "Topics", results.to_hash[:filter_fields][0][:field_title]
    assert_equal 1, results.to_hash[:filter_fields][0][:options][:options].length
    assert_equal "VAT", results.to_hash[:filter_fields][0][:options][:options][0][:title]
  end

  context 'pagination' do
    should 'build a link to the next page' do
      response = { 'total' => 200 }
      params = SearchParameters.new({
        q: 'my-query',
        count: 50,
        start: 0,
      })
      presenter = SearchResultsPresenter.new(response, params)

      assert presenter.has_next_page?
      assert_equal '/search?count=50&q=my-query&start=50', presenter.next_page_link
      assert_equal '2 of 4', presenter.next_page_label
    end

    should 'not have a next page when start + count >= total' do
      response = { 'total' => 200 }
      params = SearchParameters.new({
        count: 50,
        start: 150,
      })
      presenter = SearchResultsPresenter.new(response, params)

      assert ! presenter.has_next_page?
      assert_equal nil, presenter.next_page_link
      assert_equal nil, presenter.next_page_label
    end

    should 'build a link to the previous page' do
      response = { 'total' => 200 }
      params = SearchParameters.new({
        q: 'my-query',
        count: 50,
        start: 100,
      })
      presenter = SearchResultsPresenter.new(response, params)

      assert presenter.has_previous_page?
      assert_equal '/search?count=50&q=my-query&start=50', presenter.previous_page_link
      assert_equal '2 of 4', presenter.previous_page_label
    end

    should 'not have a previous page when start = 0' do
      response = { 'total' => 200 }
      params = SearchParameters.new({
        count: 50,
        start: 0,
      })
      presenter = SearchResultsPresenter.new(response, params)

      assert ! presenter.has_previous_page?
      assert_equal nil, presenter.previous_page_link
      assert_equal nil, presenter.previous_page_label
      assert presenter.has_next_page?
      assert_equal '/search?count=50&start=50', presenter.next_page_link
      assert_equal '2 of 4', presenter.next_page_label
    end

    should 'link to a start_at value of 0 when less than zero' do
      response = { 'total' => 200 }
      params = SearchParameters.new({
        q: 'my-query',
        count: 50,
        start: 25,
      })
      presenter = SearchResultsPresenter.new(response, params)

      # with a start value of 25 and a count of 50, this could incorrectly
      # calculate 25-50 and link to 'start=-25'. here, we assert that start=0
      # (so no start parameter is used).
      assert presenter.has_previous_page?
      assert_equal '/search?count=50&q=my-query', presenter.previous_page_link
      assert_equal '1 of 4', presenter.previous_page_label
    end

    should 'not have a previous or next page when there are no results' do
      response = { 'total' => 0 }
      params = SearchParameters.new({
        count: 50,
        start: 0,
      })
      presenter = SearchResultsPresenter.new(response, params)

      assert ! presenter.has_previous_page?
      assert ! presenter.has_next_page?

      assert_equal nil, presenter.previous_page_link
      assert_equal nil, presenter.next_page_link
    end

    should 'not have a previous or next page when there are not enough results' do
      response = { 'total' => 25 }
      params = SearchParameters.new({
        count: 50,
        start: 0,
      })
      presenter = SearchResultsPresenter.new(response, params)

      assert ! presenter.has_previous_page?
      assert ! presenter.has_next_page?

      assert_equal nil, presenter.previous_page_link
      assert_equal nil, presenter.next_page_link
    end

    should 'include the count parameter in the url when not set to the default' do
      response = { 'total' => 200 }
      params = SearchParameters.new({
        q: 'my-query',
        count: 88,
        start: 0,
      })
      presenter = SearchResultsPresenter.new(response, params)

      assert presenter.has_next_page?
      assert_equal '/search?count=88&q=my-query&start=88', presenter.next_page_link
    end
  end

  context 'grouping' do
    should "not have metadata for group results" do
      results = SearchResultsPresenter.new({
        "total" => 1,
        "results" => [ { "document_type" => "group" } ],
        "facets" => {}
      }, SearchParameters.new({q: 'my-query'}))
      rlist = results.to_hash[:results]
      assert_equal 1, rlist.size
      assert_equal nil, rlist[0][:metadata]
      assert ! rlist[0][:metadata_any?]
    end
  end
end
