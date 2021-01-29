require "test_helper"

class LocalTransactionServicesTest < ActiveSupport::TestCase
  context ".unavailable?" do
    should "include Scotland for service 461" do
      assert true, LocalTransactionServices.instance.unavailable?(461, "Scotland")
    end

    should "not include Wales for service 461" do
      assert_not LocalTransactionServices.instance.unavailable?(461, "Wales")
    end
  end

  context ".content" do
    context "Scotland" do
      should "return a string with the given country and local authority name in" do
        assert_equal "This service is unavailable in Dundee, Scotland", LocalTransactionServices.instance.content(461, "Scotland", { local_authority_name: "Dundee" })
      end

      should "return an empty string if the given content for the service is an empty string" do
        assert_equal "", LocalTransactionServices.instance.content(561, "Scotland", { local_authority_name: "Dundee" })
      end

      should "return an empty string if the given content for the service is an empty" do
        assert_equal "", LocalTransactionServices.instance.content(661, "Scotland", { local_authority_name: "Dundee" })
      end

      should "return an empty string if there is no content for the given service" do
        assert_equal "", LocalTransactionServices.instance.content(761, "Scotland", { local_authority_name: "Dundee" })
      end
    end

    context "Northern Ireland" do
      should "return a string with the given country and local authority name in" do
        assert_equal "This service is unavailable in Armagh City, Banbridge and Craigavon, Northern Ireland", LocalTransactionServices.instance.content(461, "Northern Ireland", { local_authority_name: "Armagh City, Banbridge and Craigavon" })
      end

      should "return an empty string if the given content for the service is an empty string" do
        assert_equal "", LocalTransactionServices.instance.content(561, "Northern Ireland", { local_authority_name: "Armagh City, Banbridge and Craigavon" })
      end

      should "return an empty string if the given content for the service is an empty" do
        assert_equal "", LocalTransactionServices.instance.content(661, "Northern Ireland", { local_authority_name: "Armagh City, Banbridge and Craigavon" })
      end

      should "return an empty string if there is no content for the given service" do
        assert_equal "", LocalTransactionServices.instance.content(761, "Northern Ireland", { local_authority_name: "Armagh City, Banbridge and Craigavon" })
      end
    end

    context "params" do
      should "show the un-interpolated string when no params are given" do
        assert_equal "This service is unavailable in %{local_authority_name}, Scotland", LocalTransactionServices.instance.content(461, "Scotland")
      end

      should "show the un-interpolated string when params is nil" do
        assert_equal "This service is unavailable in %{local_authority_name}, Scotland", LocalTransactionServices.instance.content(461, "Scotland", nil)
      end

      should "show the un-interpolated string when params is empty" do
        assert_equal "This service is unavailable in %{local_authority_name}, Scotland", LocalTransactionServices.instance.content(461, "Scotland", {})
      end

      should "raise a missing interpolation when local authority name is missing" do
        assert_raises I18n::MissingInterpolationArgument do
          LocalTransactionServices.instance.content(461, "Scotland", { not_required: "Testing" })
        end
      end

      should "show the interpolated string with the given params" do
        assert_equal "This service is unavailable in Bedrock, Scotland", LocalTransactionServices.instance.content(461, "Scotland", { local_authority_name: "Bedrock" })
      end
    end
  end
end
