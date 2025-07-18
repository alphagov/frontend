class HelpController < ContentItemsController
  include Cacheable

  skip_before_action :set_expiry, only: [:ab_testing]
  skip_before_action :set_locale, only: [:ab_testing]

  def index; end

  def cookie_settings; end

  def ab_testing
    ab_test = GovukAbTesting::AbTest.new("Example")
    @requested_variant = ab_test.requested_variant(request.headers)
    @requested_variant.configure_response(response)
  end

  def sign_in
    @search_services_facets = [
      {
        key: "content_purpose_supergroup[]",
        value: "services",
      },
      {
        key: "content_purpose_supergroup[]",
        value: "guidance_and_regulation",
      },
    ]

    @service_list_presenter = ServiceListPresenter.new
  end
end
