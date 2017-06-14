module BenchmarkingContactDvlaABTestable
  def should_show_benchmarking_variant?
  # Use GOVUK-ABTest-BenchmarkDVLATitle1=B header in dev to test this
    benchmark_contact_dvla_title_variant.variant_b? &&
      is_benchmarking_tested_path?
  end

  def should_show_benchmarking_lab_variant?
  # Use GOVUK-ABTest-BenchmarkDVLAButton1=B header in dev to test this
    benchmark_contact_dvla_button_variant.variant_b? &&
      is_benchmarking_lab_tested_path?
  end

  def is_benchmarking_tested_path?
    request.path.starts_with?("/contact-the-dvla")
  end

  def is_benchmarking_lab_tested_path?
    request.path == "/contact-the-dvla"
  end

  def benchmark_contact_dvla_title_variant
    @benchmark_contact_dvla_title_variant ||= benchmarking_ab_test_title.requested_variant request.headers
  end

  def set_benchmark_contact_dvla_title_response_header
    benchmark_contact_dvla_title_variant.configure_response response
  end

  def benchmark_contact_dvla_button_variant
    @benchmark_contact_dvla_button_variant ||= benchmarking_ab_test_button.requested_variant request.headers
  end

  def set_benchmark_contact_dvla_button_response_header
    benchmark_contact_dvla_button_variant.configure_response response
  end

  def self.included(base)
    base.helper_method :benchmark_contact_dvla_title_variant, :benchmark_contact_dvla_button_variant
  end

private

  def benchmarking_ab_test_title
    @ab_test_title ||= GovukAbTesting::AbTest.new("BenchmarkDVLATitle1", dimension: 48)
  end

  def benchmarking_ab_test_button
    @ab_test_button ||= GovukAbTesting::AbTest.new("BenchmarkDVLAButton1", dimension: 62)
  end
end
