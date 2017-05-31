module EducationNavigationABTestable
  EDUCATION_NAVIGATION_DIMENSION = 41

  def self.included(base)
    base.helper_method :education_navigation_variant, :ab_test_applies?
    base.after_action :set_education_navigation_response_header
  end

  def education_navigation_ab_test
    @ab_test ||=
      GovukAbTesting::AbTest.new(
        "EducationNavigation",
        dimension: EDUCATION_NAVIGATION_DIMENSION
      )
  end

  def ab_test_applies?
    content_is_linked_to_a_taxon?
  end

  def should_present_new_navigation_view?
    ab_test_applies? && education_navigation_variant.variant_b?
  end

  def education_navigation_variant
    @education_navigation_variant ||=
      education_navigation_ab_test.requested_variant(request.headers)
  end

  def content_is_linked_to_a_taxon?
    maybe_content_item.dig("links", "taxons").present?
  end

  def maybe_content_item
    content_item
  rescue GdsApi::ContentStore::ItemNotFound
    {}
  end

  def set_education_navigation_response_header
    education_navigation_variant.configure_response(response) if ab_test_applies?
  end

  def breadcrumbs
    if should_present_new_navigation_view?
      navigation_helpers.taxon_breadcrumbs
    else
      super
    end
  end
end
