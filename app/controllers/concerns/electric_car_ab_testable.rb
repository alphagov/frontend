module ElectricCarAbTestable
  CUSTOM_DIMENSION = 43
  ALLOWED_VARIANTS = %w[A B C D E F G H Z].freeze

  def self.included(base)
    base.helper_method(
      :electric_car_variant,
      :electric_car_testable?,
      :electric_car_translation_key,
    )
    base.after_action :set_electric_car_response_header
  end

  def electic_car_test
    @electic_car_test ||= GovukAbTesting::AbTest.new(
      "ElectricCarABTest",
      dimension: CUSTOM_DIMENSION,
      allowed_variants: ALLOWED_VARIANTS,
      control_variant: "Z",
    )
  end

  def electric_car_variant
    @electric_car_variant ||= electic_car_test.requested_variant(request.headers)
  end

  def electric_car_translation_key(sub_key)
    "ab_tests.electric_car.#{electric_car_variant.variant_name}.#{sub_key}"
  end

  def set_electric_car_response_header
    electric_car_variant.configure_response(response) if electric_car_testable?
  end

  def electric_car_testable?
    %w[
      done/vehicle-tax
      done/check-vehicle-tax
    ].include?(params[:slug])
  end
end
