require "test_helper"

class PostcodeSanitizerTest < ActiveSupport::TestCase
  context "postcodes are sanitized before being sent to LocationsApi" do
    should "strip trailing spaces from entered postcodes" do
      assert_equal "WC2B 6NH", PostcodeSanitizer.sanitize("WC2B 6NH ")
    end

    should "strip non-alphanumerics from entered postcodes" do
      assert_equal "WC2B 6NH", PostcodeSanitizer.sanitize("WC2B   -6NH]")
    end

    should "transpose O/0 and I/1 if necessary" do
      # Thanks to the uk_postcode gem.
      assert_equal "W1A 0AA", PostcodeSanitizer.sanitize("WIA OAA")
    end
  end

  context "if the postcode parameter is nil or an empty string" do
    should "return nil, not try to perform sanitization" do
      assert_nil PostcodeSanitizer.sanitize("")
    end
  end
end
