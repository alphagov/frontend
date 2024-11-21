module SearchAutocompleteAbTestable
  ALLOWED_VARIANTS = %w[A B Z].freeze

  def self.included(base)
    base.helper_method :search_autocomplete_ab_test_variant
    base.after_action :set_search_autocomplete_ab_test_response_header
  end

  def search_autocomplete_ab_test
    @search_autocomplete_ab_test ||= GovukAbTesting::AbTest.new(
      "SearchAutocomplete",
      allowed_variants: ALLOWED_VARIANTS,
      control_variant: "Z",
    )
  end

  def search_autocomplete_ab_test_variant
    @search_autocomplete_ab_test_variant ||= search_autocomplete_ab_test.requested_variant(request.headers)
  end

  def set_search_autocomplete_ab_test_response_header
    search_autocomplete_ab_test_variant.configure_response(response)
  end

  def show_search_autocomplete_test?
    search_autocomplete_ab_test_variant.variant?("B")
  end
end
