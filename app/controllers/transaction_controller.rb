class TransactionController < ApplicationController
  include Cacheable
  include Navigable

  before_action :set_content_item
  before_action :deny_framing

  def show
    if request.params['slug'] == 'view-driving-licence'
      ab_test = GovukAbTesting::AbTest.new(
        'ViewDrivingLicence',
        dimension: 68,
        allowed_variants: %w(A B),
        control_variant: 'A'
      )
      @requested_variant = ab_test.requested_variant(request.headers)
      @requested_variant.configure_response(response)

      if @requested_variant.variant?('B')
        render "transaction_variant/show"
      else
        @ab_test_a_variant = true
        render "show"
      end
    end
  end

private

  def set_content_item
    super(TransactionPresenter)
  end

  def deny_framing
    response.headers['X-Frame-Options'] = 'DENY'
  end
end
