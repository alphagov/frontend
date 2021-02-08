require "test_helper"

class LocalTransactionServiceTest < ActiveSupport::TestCase
  setup do
    @unavailable_service = LocalTransactionService.new("Service name", 461, "Scotland", "https://www.la.gov.uk")
    @available_service = LocalTransactionService.new("Service name", 461, "England", "https://www.la.gov.uk")
  end

  context ".unavailable?" do
    should "return false if no unavailable content" do
      assert_equal false, @available_service.unavailable?
    end

    should "return true if unavailable content" do
      assert true, @unavailable_service.unavailable?
    end
  end

  context ".body" do
    should "returns string if defined in config" do
      assert_equal "Body content", @unavailable_service.body
    end

    should "returns nil if not defined" do
      assert_nil @available_service.body
    end
  end

  context ".button_text" do
    should "returns string if defined in config" do
      assert_equal "Custom button text", @unavailable_service.button_text
    end

    should "return an default string if not defined" do
      assert_equal "Find other services", @available_service.button_text
    end
  end

  context ".button_link" do
    should "returns string if defined in config" do
      assert_equal "https://gov.scot", @unavailable_service.button_link
    end

    should "returns local authority homepage if not defined" do
      assert_equal "https://www.la.gov.uk", @available_service.button_link
    end
  end

  context ".title" do
    should "returns string if defined in config" do
      assert_equal "Custom title", @unavailable_service.title
    end

    should "returns service name if not defined" do
      assert_equal "Service name", @available_service.title
    end
  end
end
