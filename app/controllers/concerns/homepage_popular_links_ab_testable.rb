module HomepagePopularLinksAbTestable
  CUSTOM_DIMENSION = 67

  ALLOWED_VARIANTS = %w[A B C D Z].freeze

  def self.included(base)
    base.helper_method(
      :homepage_popular_links_ab_test_variant,
      :page_under_test?,
      :variant_b_page?,
      :variant_c_page?,
      :variant_d_page?,
    )
    base.after_action :set_homepage_popular_links_test_response_header
  end

  def homepage_popular_links_test
    @homepage_popular_links_test ||= GovukAbTesting::AbTest.new(
      "HomepagePopularLinksTest",
      dimension: CUSTOM_DIMENSION,
      allowed_variants: ALLOWED_VARIANTS,
      control_variant: "Z",
    )
  end

  def homepage_popular_links_ab_test_variant
    @homepage_popular_links_ab_test_variant ||= homepage_popular_links_test.requested_variant(request.headers)
  end

  def set_homepage_popular_links_test_response_header
    homepage_popular_links_ab_test_variant.configure_response(response) if page_under_test?
  end

  def variant_b_page?
    page_under_test? && homepage_popular_links_ab_test_variant.variant?("B")
  end

  def variant_c_page?
    page_under_test? && homepage_popular_links_ab_test_variant.variant?("C")
  end

  def variant_d_page?
    page_under_test? && homepage_popular_links_ab_test_variant.variant?("D")
  end

  def page_under_test?
    request.path == "/"
  end
end
