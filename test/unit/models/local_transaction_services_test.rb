require "test_helper"

class LocalTransactionServicesTest < ActiveSupport::TestCase
  context ".unavailable?" do
    should "include Scotland for service 461" do
      assert true, LocalTransactionServices.instance.unavailable?(461, "Scotland")
    end

    should "not include Northern Ireland for service 461" do
      assert_not LocalTransactionServices.instance.unavailable?(461, "Northern Ireland")
    end
  end
end
