require 'integration_test_helper'

class OldRelatedLinksTest < ActionDispatch::IntegrationTest
  include EducationNavigationAbTestHelper

  context "a page with an override to show old related links in A/B test" do
    setup do
      setup_education_navigation_ab_test
    end

    MainstreamContentFetcher.with_curated_sidebar.each do |base_path|
      should "show the old related links for #{base_path} in the B variant" do
        stub_request(:get, %r{/search.json})
        content_store_has_example_item(
          base_path,
          schema: 'transaction',
          is_tagged_to_taxon: true
        )

        expect_normal_navigation_and_old_related_links

        with_variant EducationNavigation: "B" do
          visit base_path
        end
      end
    end
  end
end
