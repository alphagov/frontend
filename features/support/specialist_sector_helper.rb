require 'gds_api/test_helpers/content_api'

module SpecialistSectorHelper
  include GdsApi::TestHelpers::ContentApi

  def stub_specialist_sector_topics
    @grouped_content = {
      "Services" => [
        "what-is-oil",
        "apply-for-an-oil-licence"
      ],
      "Guidance" => [
        "environmental-policy",
        "onshore-exploration-and-production"
      ],
      "Forms" => [
        "well-application-form"
      ],
      "Statistics" => [
        "well-report-2014",
        "oil-extraction-count-2013"
      ]
    }

    content_api_has_tag("specialist_sector","oil-and-gas/fields-and-wells","oil-and-gas")
    content_api_has_grouped_artefacts_with_a_tag("specialist_sector", "oil-and-gas/fields-and-wells", "format", @grouped_content)
  end

  def visit_specialist_sector_topic
    visit "/oil-and-gas/fields-and-wells"
  end

  def assert_presence_of_grouped_specialist_sector_content
    # for each group in the hash, we check whether there is a
    # nav block in the page with the group label header
    @grouped_content.each do |name,slugs|
      within "nav.#{name.parameterize}" do
        assert page.has_selector?("h1", text: name)

        # iterate over each expected slug for the group and assert that
        # the link is present in the list
        slugs.each do |slug|
          assert page.has_selector?("a[href='http://frontend.test.gov.uk/#{slug}']")
        end
      end
    end # each
  end

  def assert_no_headings_for_empty_format_groups
    within ".specialist-sector-browse" do
      assert page.has_no_content?("h1", text: "Announcements")
      assert page.has_no_content?("h1", text: "Statutory guidance")
      assert page.has_no_content?("h1", text: "Maps")
    end
  end
end

World(SpecialistSectorHelper)
