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
        }
      )
    )
  end

  def teardown_education_navigation_ab_test
    ENV['ENABLE_NEW_NAVIGATION'] = nil
  end

  def sidebar
    Nokogiri::HTML.parse(response.body).at_css(".related-container")
  end

  def assert_normal_navigation_visible
    assert_match(/NormalBreadcrumb/, response.body)
    refute_match(/TaxonBreadcrumb/, response.body)
    refute_match(/A Taxon/, sidebar)
  end

  def assert_taxonomy_navigation_visible
    assert_match(/TaxonBreadcrumb/, response.body)
    refute_match(/NormalBreadcrumb/, response.body)
    assert_match(/A Taxon/, sidebar)
  end
end
