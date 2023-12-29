module HmrcTemporaryAbTestable
  CUSTOM_DIMENSION = 47 ## Not sure if this is correct

  ALLOWED_VARIANTS = %w[A B Z].freeze

  def self.included(base)
    base.helper_method(
      :hmrc_temporary_ab_test_variant,
      :hmrc_temporary_ab_test_page?,
      :hmrc_temporary_ab_test_variant_b?,
    )
    base.after_action :set_hmrc_temporary_ab_test_response_header
  end

  def hmrc_temporary_ab_test_variant_b?
    hmrc_temporary_ab_test_page? && hmrc_temporary_ab_test_variant.variant?("B")
  end

  def hmrc_temporary_ab_test_page?
    request.path == "/self-assessment-ready-reckoner"
  end

  def hmrc_temporary_ab_test_variant
    @hmrc_temporary_ab_test_variant ||= hmrc_temporary_ab_test.requested_variant(request.headers)
  end

  def hmrc_temporary_ab_test
    @hmrc_temporary_ab_test ||= GovukAbTesting::AbTest.new(
      "ReadyReckonerVideoTest",
      dimension: CUSTOM_DIMENSION,
      allowed_variants: ALLOWED_VARIANTS,
      control_variant: "Z",
    )
  end

  def set_hmrc_temporary_ab_test_response_header
    hmrc_temporary_ab_test_variant.configure_response(response) if hmrc_temporary_ab_test_page?
  end
end
