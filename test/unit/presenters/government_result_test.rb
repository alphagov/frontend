require_relative "../../test_helper"

class GovernmentResultTest < ActiveSupport::TestCase
  should "display a description" do
    result = GovernmentResult.new("description" => "I like pie.")
    assert_equal "I like pie.", result.display_a_description
  end

  should "truncate descriptions at word boundaries" do
    long_description = %Q{You asked me to oversee a strategic review of
Directgov and to report to you by the end of September. I have undertaken this
review in the context of my wider remit as UK Digital Champion which includes
offering advice on "how efficiencies can best be realised through the online
delivery of public services."}
    truncated_description = %Q{You asked me to oversee a strategic review of
Directgov and to report to you by the end of September. I have undertaken this
review in the context of my wider remit as UK Digital Champion which includes
offering...}
    result = GovernmentResult.new("description" => long_description)
    assert_equal truncated_description, result.display_a_description
  end

  should "report a lack of location field as no locations" do
    result = GovernmentResult.new({})
    assert_false result.has_world_locations?
  end

  should "report an empty list of locations as no locations" do
    result = GovernmentResult.new("world_locations" => [])
    assert_false result.has_world_locations?
  end

  should "display a single world location" do
    france = {"title" => "France", "slug" => "france"}
    result = GovernmentResult.new("world_locations" => [france])
    assert result.has_world_locations?
    assert_equal "France", result.display_world_locations
  end

  should "not display individual locations when there are several" do
    france = {"title" => "France", "slug" => "france"}
    spain = {"title" => "Spain", "slug" => "spain"}
    result = GovernmentResult.new("world_locations" => [france, spain])
    assert result.has_world_locations?
    assert_equal "multiple locations", result.display_world_locations
  end
end
