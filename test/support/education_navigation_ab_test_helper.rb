module EducationNavigationAbTestHelper
  include GovukAbTesting::MinitestHelpers

  def setup_education_navigation_ab_test
    content_store_has_page("tagged-to-taxon", is_tagged_to_taxon: true)
  end

  def sidebar
    Nokogiri::HTML.parse(response.body).at_css(".related-container")
  end

  def expect_normal_navigation
    GovukNavigationHelpers::NavigationHelper.any_instance.expects(:breadcrumbs).returns(breadcrumbs: [])
    GovukNavigationHelpers::NavigationHelper.any_instance.expects(:related_items)
  end

  def expect_new_navigation
    GovukNavigationHelpers::NavigationHelper.any_instance.expects(:taxon_breadcrumbs).returns(breadcrumbs: [])
    GovukNavigationHelpers::NavigationHelper.any_instance.expects(:taxonomy_sidebar)
  end
end
