require "test_helper"

class ScopedSearchResultsPresenterTest < ActiveSupport::TestCase
  setup do
    @scope_title = stub
    @unscoped_result_count = stub

    @scoped_results = [{"title"=> "scoped_result_1"},
                       {"title"=> "scoped_result_2"},
                       {"title"=> "scoped_result_3"},
                       {"title"=> "scoped_result_4"},
                       ]
    @unscoped_results = [{"title"=> "unscoped_result_1"},
                        {"title"=> "unscoped_result_2"},
                        {"title"=> "unscoped_result_3"},
                        ]

    @search_response =  { "result_count" => "50",
                          "results" => @scoped_results,
                          "scope" => {
                            "title" => @scope_title,
                          },
                          "unscoped_results" => {
                            "total" => @unscoped_result_count,
                            "results" => @unscoped_results,
                          },
                        }


    @search_parameters = stub(search_term: 'words',
                              debug_score: 1,
                              start: 1,
                              count: 1,
                              build_link: 1,
                              enable_highlighting?: false,
                              )
  end

  should "return a hash that has is_scoped set to true" do
    results = ScopedSearchResultsPresenter.new(@search_response, @search_parameters)
    assert_equal true, results.to_hash[:is_scoped?]
  end

  should "return a hash with the scope_title set to the scope title from the @search_response" do
    results = ScopedSearchResultsPresenter.new(@search_response, @search_parameters)
    assert_equal @scope_title, results.to_hash[:scope_title]
  end

  should "return a hash result count set to the scope title from the @search_response" do
    results = ScopedSearchResultsPresenter.new(@search_response, @search_parameters)
    assert_equal "#{@unscoped_result_count} results", results.to_hash[:unscoped_result_count]
  end

  context "presentable result list" do

    should "return all scoped results with unscoped results inserted at position 4" do
      results = ScopedSearchResultsPresenter.new(@search_response, @search_parameters).to_hash

      ##
      # This test is asserting that the format of `presentable_list` is:
      # [result, result, result, {results: list_of_results, is_multiple_results: true}, result ...]
      # Where list_of_results are the top three results from an unscoped request to rummager
      # and a flag `is_multiple_results` set to true.
      ##

      simplified_expected_results_list = [{ "title"=> "scoped_result_1" },
                               { "title"=> "scoped_result_2" },
                               { "title"=> "scoped_result_3" },
                               { "is_multiple_results" => true,
                                 "results" => [{ "title"=> "unscoped_result_1" },
                                               { "title"=> "unscoped_result_2" },
                                               { "title"=> "unscoped_result_3" },
                                              ]
                                },
                                { "title"=> "scoped_result_4" },
                              ]


      # Scoped results
      simplified_expected_results_list[0..2].each_with_index do | result, i |
        assert_equal result["title"], results[:results][i][:title]
      end

      # Check un-scoped sub-list has flag
      assert_equal true, results[:results][3][:is_multiple_results]

      # iterate unscoped sublist of results
      simplified_expected_results_list[3]["results"].each_with_index do | result, i |
        assert_equal result["title"], results[:results][3][:results][i][:title]
      end

      # check remaining result
      assert_equal simplified_expected_results_list[4]["title"], results[:results][4][:title]
    end
  end

  context "no scoped results returned" do
    setup do
      @no_results = []
      @search_response["unscoped_results"]["results"] = @no_results
    end

    should "not not include unscoped results in the presentable_list if there aren't any" do
      results = ScopedSearchResultsPresenter.new(@search_response, @search_parameters).to_hash

      @scoped_results.each_with_index do | result, i |
        assert_equal result["title"], results[:results][i][:title]
      end
    end

    should "not set unscoped_results_any? to false" do
      results = ScopedSearchResultsPresenter.new(@search_response, @search_parameters).to_hash
      assert_equal false, results.to_hash[:unscoped_results_any?]
    end
  end
end
