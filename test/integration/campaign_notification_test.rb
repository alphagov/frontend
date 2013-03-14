require_relative "../integration_test_helper"

class CampaignNotificationTest < ActionDispatch::IntegrationTest
  should "show the campaign notification if the campaign template exists" do
    visit "/"
    assert_equal true, page.has_selector?("#campaign-notification")
  end
end
