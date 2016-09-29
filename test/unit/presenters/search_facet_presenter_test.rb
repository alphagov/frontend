require "test_helper"

class SearchFacetPresenterTest < ActiveSupport::TestCase
  should "return an appropriate hash" do
    facet = SearchFacetPresenter.new({
      "options" => [{
        "value" => {
          "slug" => "department-for-education",
          "title" => "Department for Education"
        },
        "documents" => 1114
      }]
    }, ['department-for-education'])
    assert_equal true, facet.to_hash[:any?]
    assert_equal 'department-for-education', facet.to_hash[:options][0][:slug]
    assert_equal 'Department for Education', facet.to_hash[:options][0][:title]
    assert_equal '1,114', facet.to_hash[:options][0][:count]
    assert_equal true, facet.to_hash[:options][0][:checked]
  end

  should "work out which items are checked" do
    facet = SearchFacetPresenter.new({
      "options" => [{
        "value" => {
          "slug" => "department-for-education",
          "title" => "Department for Education"
        },
        "documents" => 1114
      }, {
        "value" => {
          "slug" => "department-for-transport",
          "title" => "Department for Transport"
        },
        "documents" => 1114
      }]
    }, ['department-for-education'])
    assert_equal 'department-for-education', facet.to_hash[:options][0][:slug]
    assert_equal true, facet.to_hash[:options][0][:checked]
    assert_equal 'department-for-transport', facet.to_hash[:options][1][:slug]
    assert_equal false, facet.to_hash[:options][1][:checked]
  end
end
