require_relative "../../test_helper"

class GovernmentResultTest < ActiveSupport::TestCase
  should "display a description" do
    result = GovernmentResult.new("description" => "I like pie.")
    assert_equal "I like pie.", result.description
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
    assert_equal truncated_description, result.description
  end

  should "report a lack of location field as no locations" do
    result = GovernmentResult.new({})
    assert result.metadata.empty?
  end

  should "report an empty list of locations as no locations" do
    result = GovernmentResult.new("world_locations" => [])
    assert result.metadata.empty?
  end

  should "display a single world location" do
    france = {"title" => "France", "slug" => "france"}
    result = GovernmentResult.new("world_locations" => [france])
    assert_equal "France", result.metadata[0]
  end

  should "not display individual locations when there are several" do
    france = {"title" => "France", "slug" => "france"}
    spain = {"title" => "Spain", "slug" => "spain"}
    result = GovernmentResult.new("world_locations" => [france, spain])
    assert_equal "multiple locations", result.metadata[0]
  end

  should "return valid metadata" do
    result = GovernmentResult.new({
      "public_timestamp" => "2014-10-14",
      "display_type" => "my-display-type",
      "organisations" => [ { "slug" => "org-1" } ],
      "world_locations" => [ {"title" => "France", "slug" => "france"} ]
    })
    assert_equal result.metadata, [ '14 October 2014', 'my-display-type', 'org-1', 'France' ]
  end

  should "return format for corporate information pages in metadata" do
    result = GovernmentResult.new({
      "format" => "corporate_information"
    })
    assert_equal result.metadata, [ 'Corporate information' ]
  end

  should "return only display type for corporate information pages if it is present in metadata" do
    result = GovernmentResult.new({
      "display_type" => "my-display-type",
      "format" => "corporate_information"
    })
    assert_equal result.metadata, [ "my-display-type" ]
  end

  should "not return sections for deputy prime ministers office" do
    result = GovernmentResult.new({
      "format" => "organisation",
      "link" => "/government/organisations/deputy-prime-ministers-office",
    })
    assert_nil result.sections
  end

  should "return sections for some format types" do
    minister_results               = GovernmentResult.new({ "format" => "minister" })
    organisation_results           = GovernmentResult.new({ "format" => "organisation" })
    person_results                 = GovernmentResult.new({ "format" => "person" })
    world_location_results         = GovernmentResult.new({ "format" => "world_location" })
    worldwide_organisation_results = GovernmentResult.new({ "format" => "worldwide_organisation" })
    mainstream_results             = GovernmentResult.new({ "format" => "mainstream" })

    assert_equal 2, minister_results.sections.length
    assert_equal nil, organisation_results.sections
    assert_equal 2, person_results.sections.length
    assert_equal 2, world_location_results.sections.length
    assert_equal 2, worldwide_organisation_results.sections.length

    assert_equal nil, mainstream_results.sections
  end

  should "return sections in correct format" do
    minister_results = GovernmentResult.new({ "format" => "minister" })

    assert_equal [:hash, :title], minister_results.sections.first.keys
  end

  should "return description for detailed guides" do
    result = GovernmentResult.new({
      "format" => "detailed_guidance",
      "description" => "my-description"
    })
    assert_equal result.description, 'my-description'
  end

  should "return description for organisation" do
    result = GovernmentResult.new({
      "format" => "organisation",
      "title" => "my-title",
      "description" => "my-description"
    })
    assert_equal result.description, 'The home of my-title on GOV.UK. my-description'
  end

  should "return description for other formats" do
    result = GovernmentResult.new({
      "format" => "my-new-format",
      "description" => "my-description"
    })
    assert_equal result.description, 'my-description'
  end

  should "mark titles of closed organisations as being closed" do
    result = GovernmentResult.new({
      "format" => "organisation",
      "organisation_state" => "closed",
      "title" => "my-title",
      "description" => "my-description",
    })
    assert_equal result.title, 'Closed organisation: my-title'
    assert_equal result.description, 'my-description'
  end
end
