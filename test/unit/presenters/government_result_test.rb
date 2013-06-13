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
end
