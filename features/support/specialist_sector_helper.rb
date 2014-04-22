require 'gds_api/test_helpers/content_api'

module SpecialistSectorHelper
  include GdsApi::TestHelpers::ContentApi

  def stub_specialist_sector_topics
    @content = [
      "what-is-oil",
      "apply-for-an-oil-licence",
      "environmental-policy",
      "onshore-exploration-and-production",
      "well-application-form",
      "well-report-2014",
      "oil-extraction-count-2013"
    ]

    content_api_has_tag("specialist_sector","oil-and-gas/fields-and-wells","oil-and-gas")
    content_api_has_artefacts_with_a_tag("specialist_sector", "oil-and-gas/fields-and-wells", @content)
  end

  def visit_specialist_sector_topic
    visit "/oil-and-gas/fields-and-wells"
  end

  def assert_presence_of_specialist_sector_content
    @content.each do |slug|
      assert page.has_selector?("a[href='http://frontend.test.gov.uk/#{slug}']")
    end
  end
end

World(SpecialistSectorHelper)
