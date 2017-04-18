require 'test_helper'
require 'emergency_banner'

class EmergencyBannerTest < ActiveSupport::TestCase
  setup do
    @emergency_banner = EmergencyBanner.new
  end
  context "emergency banner" do
    should "return enabled if heading and campaign class are set" do
      expected_hash = { heading: "Emergency", campaign_class: "black" }
      Redis.any_instance.stubs(:hgetall).with("emergency_banner").returns(expected_hash)
      assert @emergency_banner.enabled?
    end

    should "return enabled as false if heading is set but campaign class is not" do
      expected_hash = { heading: "Emergency" }
      Redis.any_instance.stubs(:hgetall).with("emergency_banner").returns(expected_hash)
      refute @emergency_banner.enabled?
    end

    should "return enabled as false if campaign class is set but heading is not" do
      expected_hash = { campaign_class: "black" }
      Redis.any_instance.stubs(:hgetall).with("emergency_banner").returns(expected_hash)
      refute @emergency_banner.enabled?
    end

    should "return enabled as false if neither heading nor campaign class is set" do
      Redis.any_instance.stubs(:hgetall).with("emergency_banner").returns({})
      refute @emergency_banner.enabled?

      expected_hash = { heading: "", campaign_class: "" }
      Redis.any_instance.stubs(:hgetall).with("emergency_banner").returns(expected_hash)
      refute @emergency_banner.enabled?
    end
  end
end
