require 'test_helper'
require 'search_api'

# TODO: Make these tests better once the fires have gone out. tgladhill 15/12/16
class SearchAPITest < ActiveSupport::TestCase
  # setup do
  #   @rummager_api = stub
  #   @rummager_params = stub(except: {})
  #   @search_params = stub(rummager_parameters: @rummager_params)
  #   @search_api = SearchAPI.new(@rummager_api)
  #   @search_results = stub
  #   @rummager_response = stub(to_hash: { results: @search_results })
  #   @rummager_api.expects(:search).with(@rummager_params).returns(@rummager_response)
  # end

  # context "given an unscoped search" do
  #   setup do
  #     @search_params.expects(:filtered_by?).with('manual').returns(false)
  #   end

  #   should "returns search results from rummager" do
  #     search_response = @search_api.search(@search_params)
  #     assert_equal(@search_results, search_response.fetch(:results))
  #   end
  # end

  # context "given a search scoped to a manual" do
  #   setup do
  #     @manual_link = '/manual/manual-name'
  #     @manual_title = 'Manual Title'

  #     @govuk_result_title = "GOV.UK result"

  #     @search_params.expects(:filtered_by?).with('manual').returns(true)
  #     @search_params.expects(:filter).with('manual').returns([@manual_link])
  #     @manual_search_response = stub(to_hash: { results:  [{ title: @manual_title }] })
  #     @unscoped_search_response = stub(to_hash: { title: @govuk_result_title })

  #     @rummager_api.expects(:search).with(count: "3", reject_manual: @manual_link).returns(@unscoped_search_response)
  #     @rummager_api.expects(:search).with(filter_link: @manual_link, count: "1", fields: %w{title}).returns(@manual_search_response)
  #   end

  #   should "return search results from rummager" do
  #     search_response = @search_api.search(@search_params)
  #     assert_equal(@search_results, search_response.fetch(:results))
  #   end

  #   should "return manual from rummager" do
  #     search_response = @search_api.search(@search_params)
  #     assert_equal({ "title" => @manual_title }, search_response.fetch("scope"))
  #   end

  #   should "return three results for the whole of gov.uk from rummager" do
  #     search_response = @search_api.search(@search_params)
  #     assert_equal({ title: @govuk_result_title }, search_response.fetch("unscoped_results"))
  #   end
  # end
end
