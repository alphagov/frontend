class HelpController < ApplicationController
  include ApiRedirectable
  include Cacheable

  before_filter -> { setup_content_item_and_navigation_helpers("/" + params[:slug]) }, only: :show

  def index
    setup_content_item_and_navigation_helpers("/help")
  end

  def tour
    setup_content_item_and_navigation_helpers("/tour")
    render locals: { full_width: true }
  end

  def show
    set_content_item(HelpPagePresenter)
  end

  def ab_testing
    ab_test = GovukAbTesting::AbTest.new("Example", dimension: 40)
    @requested_variant = ab_test.requested_variant(request)
    @requested_variant.configure_response(response)
  end

private

  def slug_param
    params[:slug] || 'help'
  end
end
