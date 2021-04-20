require "test_helper"

class ElectionPostcodeTest < ActiveSupport::TestCase
  context "#present?" do
    should "return true if sanitised_postcode not blank" do
      subject = ElectionPostcode.new("SW1A 1AA")

      assert_equal(true, subject.present?)
    end
  end

  context "#valid?" do
    should "Check that the postcode meets our regex" do
      subject = ElectionPostcode.new("NOTVALID")

      assert_equal(false, subject.valid?)
    end

    should "pass valid postcodes" do
      subject = ElectionPostcode.new("E10 8QS")

      assert_equal(true, subject.valid?)
    end
  end

  context "#sanitized_postcode" do
    should "Converts the postcode into upper case and discards non-alpha characters" do
      subject = ElectionPostcode.new("sW1a++*1aA")

      assert_equal("SW1A 1AA", subject.sanitized_postcode)
    end
  end

  context "#postcode_for_api" do
    should "use the sanitized postcode and strip whitespace" do
      subject = ElectionPostcode.new("SW1A  +  1AA")

      assert_equal("SW1A1AA", subject.postcode_for_api)
    end
  end

  context "#errors" do
    should "detect empty postcode after validation" do
      subject = ElectionPostcode.new("  +  ")

      assert_equal("invalidPostcodeFormat", subject.error)
    end

    should "detect invalid postcode" do
      subject = ElectionPostcode.new("Also invalid")

      assert_equal("invalidPostcodeFormat", subject.error)
    end
  end
end
