class HelpController < ApplicationController
  include Cacheable

  def index
    fetch_and_setup_content_item("/help")
    slimmer_template "gem_layout"
  end

  def tour
    fetch_and_setup_content_item("/tour")
    slimmer_template "gem_layout"
  end

  def cookie_settings
    fetch_and_setup_content_item("/help/cookies")
  end

  def ab_testing
    fetch_and_setup_content_item("/help/ab-testing")
    ab_test = GovukAbTesting::AbTest.new("Example", dimension: 40)
    @requested_variant = ab_test.requested_variant(request.headers)
    @requested_variant.configure_response(response)
  end

private

  def slug_param
    params[:slug] || "help"
  end
end
