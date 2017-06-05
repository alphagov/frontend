module BenchmarkingContactDvlaTitleABTestable
  def should_show_benchmarking_variant?
  # Use GOVUK-ABTest-BenchmarkDVLATitle1=B header in dev to test this
    benchmark_contact_dvla_title_variant.variant_b? &&
      is_benchmarking_tested_path?
  end

  def is_benchmarking_tested_path?
    request.path.starts_with?("/contact-the-dvla")
  end

  def benchmark_contact_dvla_title_variant
    @benchmark_contact_dvla_title_variant ||= benchmarking_ab_test.requested_variant request.headers
  end

  def set_benchmark_contact_dvla_title_response_header
    benchmark_contact_dvla_title_variant.configure_response response
  end

  def self.included(base)
    base.helper_method :benchmark_contact_dvla_title_variant
  end

private

  def benchmarking_ab_test
    @ab_test ||= GovukAbTesting::AbTest.new("BenchmarkDVLATitle1", dimension: 48)
  end
end
