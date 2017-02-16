module EducationNavigationAbTestHelper
  include GovukAbTesting::MinitestHelpers

  def setup_education_navigation_ab_test
    set_new_navigation
    content_api_and_content_store_have_page_tagged_to_taxon("a-slug")
    stub_controller_ab_test
  end

  def set_new_navigation
    ENV['ENABLE_NEW_NAVIGATION'] = 'yes'
  end

  def stub_controller_ab_test
    @controller.stubs(
      navigation_helpers: stub(
        'navigation_helpers',
        breadcrumbs: {
          breadcrumbs: ['NormalBreadcrumbs'],
        },
        taxon_breadcrumbs: {
          breadcrumbs: ['TaxonBreadcrumbs'],
        },
      )
    )
  end

  def teardown_education_navigation_ab_test
    ENV['ENABLE_NEW_NAVIGATION'] = nil
  end
end
