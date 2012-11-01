require_relative "../integration_test_helper"

class CampaignNotificationTest < ActionDispatch::IntegrationTest
  should "show the campaign notification if the campaign template exists" do
    mocked = mock("response")
    mocked.expects(:to_hash).once.returns(nil)
    GdsApi::ContentApi.any_instance.expects(:root_sections).once.returns(mocked)

    visit "/"
    assert_equal true, page.has_selector?("#campaign-notification")
  end
end
