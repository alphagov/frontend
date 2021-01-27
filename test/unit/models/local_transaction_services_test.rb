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

  context ".content" do
    should "return a string with the given country and local authority name in" do
      assert_equal "This service is unavailable in Dundee, Scotland", LocalTransactionServices.instance.content(461, "Scotland", "Dundee")
    end

    should "return an empty string if the given content for the service is an empty string" do
      assert_equal "", LocalTransactionServices.instance.content(561, "Scotland", "Dundee")
    end

    should "return an empty string if the given content for the service is an empty" do
      assert_equal "", LocalTransactionServices.instance.content(661, "Scotland", "Dundee")
    end

    should "return an empty string if there is no content for the given service" do
      assert_equal "", LocalTransactionServices.instance.content(761, "Scotland", "Dundee")
    end
  end
end
