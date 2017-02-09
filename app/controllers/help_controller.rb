class HelpController < ApplicationController
  include ApiRedirectable
  include Previewable
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
    if viewing_draft_content?
      set_publication
    else
      set_content_item
    end
  end

  def ab_testing
    ab_test = GovukAbTesting::AbTest.new("example")
    @ab_variant = ab_test.requested_variant(request)
    @ab_variant.configure_response(response)
  end

private

  def slug_param
    params[:slug] || 'help'
  end
end
