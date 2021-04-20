require "test_helper"

class UprnTest < ActiveSupport::TestCase
  context "#valid?" do
    should "fail uprns with non-numerical characters" do
      subject = Uprn.new("1234-34")

      assert_equal(false, subject.valid?)
    end

    should "fail uprns that are too long" do
      subject = Uprn.new("12345678910110")

      assert_equal(false, subject.valid?)
    end

    should "pass valid uprns - some digits" do
      subject = Uprn.new("12345")

      assert_equal(true, subject.valid?)
    end

    should "pass valid uprns - 12 digits" do
      subject = Uprn.new("012345678910")

      assert_equal(true, subject.valid?)
    end

    should "pass valid uprns - ignoring whitespace" do
      subject = Uprn.new(" 012345678910 ")

      assert_equal(true, subject.valid?)
    end
  end

  context "#uprn" do
    should "should trim surrounding whitespace" do
      subject = Uprn.new(" 123456789 ")

      assert_equal("123456789", subject.sanitized_uprn)
    end
  end

  context "#errors" do
    should "detect empty uprn after sanitization" do
      subject = Uprn.new("    ")

      assert_equal("uprnLeftBlankSanitized", subject.error)
    end

    should "detect invalid uprn" do
      subject = Uprn.new("Also invalid")

      assert_equal("invalidUprnFormat", subject.error)
    end
  end
end
