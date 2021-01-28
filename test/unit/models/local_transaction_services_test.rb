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
    setup do
      @params = {
        country_name: "Scotland",
        local_authority_name: "Dundee",
      }
    end

    context "country" do
      should "return a string with the given country and local authority name in" do
        assert_equal "This service is unavailable in Dundee, Scotland", LocalTransactionServices.instance.content(461, "countries", @params)
      end
    end

    context "local authority" do
      should "return the content for unavailable local authorities" do
        assert_equal "This service is unavailable in that local authority", LocalTransactionServices.instance.content(461, "local_authorities", {})
      end
    end

    context "with parameters" do
      should "return an empty string if the given content for the service is an empty string" do
        assert_equal "", LocalTransactionServices.instance.content(561, "local_authorities", @params)
      end

      should "return an empty string if the given content for the service is an empty" do
        assert_equal "", LocalTransactionServices.instance.content(661, "countries", @params)
      end

      should "return an empty string if there is no content for the given service" do
        assert_equal "", LocalTransactionServices.instance.content(761, "local_authorities", @params)
      end
    end

    context "with empty parameter hash" do
      should "return an empty string if the given content for the service is an empty string" do
        assert_equal "", LocalTransactionServices.instance.content(561, "countries", {})
      end

      should "return an empty string if the given content for the service is an empty" do
        assert_equal "", LocalTransactionServices.instance.content(661, "local_authorities", {})
      end

      should "return an empty string if there is no content for the given service" do
        assert_equal "", LocalTransactionServices.instance.content(761, "countries", {})
      end
    end

    context "with nil parameter hash" do
      should "return an empty string if the given content for the service is an empty string" do
        assert_equal "", LocalTransactionServices.instance.content(561, "local_authorities", nil)
      end

      should "return an empty string if the given content for the service is an empty" do
        assert_equal "", LocalTransactionServices.instance.content(661, "countries", nil)
      end

      should "return an empty string if there is no content for the given service" do
        assert_equal "", LocalTransactionServices.instance.content(761, "local_authorities", nil)
      end
    end

    context "without a parameter hash" do
      should "return an empty string if the given content for the service is an empty string" do
        assert_equal "", LocalTransactionServices.instance.content(561, "countries")
      end

      should "return an empty string if the given content for the service is an empty" do
        assert_equal "", LocalTransactionServices.instance.content(661, "local_authorities")
      end

      should "return an empty string if there is no content for the given service" do
        assert_equal "", LocalTransactionServices.instance.content(761, "countries")
      end
    end
  end
end
