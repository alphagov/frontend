module BankHolAbTestable
  ALLOWED_VARIANTS = %w[A B].freeze

  def self.included(base)
    base.helper_method(
      :bank_hol_ab_test_variant,
      :page_under_test?,
      :variant_b_page?,
    )
    base.after_action :set_bank_hol_ab_test_response_header
  end

  def bank_hol_ab_test
    @bank_hol_ab_test ||= GovukAbTesting::AbTest.new(
      "BankHolidaysTest",
      allowed_variants: ALLOWED_VARIANTS,
    )
  end

  def bank_hol_ab_test_variant
    @bank_hol_ab_test_variant ||= bank_hol_ab_test.requested_variant(request.headers)
  end

  def set_bank_hol_ab_test_response_header
    bank_hol_ab_test_variant.configure_response(response) if page_under_test?
  end

  def variant_b_page?
    page_under_test? && bank_hol_ab_test_variant.variant?("B")
  end

  def page_under_test?
    request.path == "/bank-holidays"
  end
end
