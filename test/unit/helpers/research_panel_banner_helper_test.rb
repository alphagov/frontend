require "test_helper"

class ResearchPanelBannerHelperTest < ActionView::TestCase
  include ResearchPanelBannerHelper

  setup do
    @signup_url = ResearchPanelBannerHelper::SIGNUP_URL
  end

  test "return SIGNUP_URL for /bank-holidays" do
    assert_equal @signup_url, signup_url_for("/bank-holidays")
  end
end
