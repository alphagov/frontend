require "test_helper"

class CsvPreviewServiceTest < ActionController::TestCase
  subject { CsvPreviewService.new(id: nil, filename: nil) }

  context "#newline_or_last_char_index" do
    context "when newline index is less than index of last newline" do
      should "return correct index" do
        assert_equal 8, subject.send(:newline_or_last_char_index, "a\nb\ncdef\ngh\nijk", 2)
      end
    end
    context "when newline index is equal to index of last newline" do
      should "return correct index" do
        assert_equal 11, subject.send(:newline_or_last_char_index, "a\nb\ncdef\ngh\n", 3)
      end
    end
    context "when newline index is greater than index of last newline" do
      should "return correct index" do
        assert_equal 14, subject.send(:newline_or_last_char_index, "a\nb\ncdef\ngh\nijk", 10)
      end
    end
  end

  context "#truncate_to_maximum_number_of_lines" do
    context "when requested number of lines is less than actual number of lines" do
      should "return correct string" do
        assert_equal "a\nb\ncdef\n", subject.send(:truncate_to_maximum_number_of_lines, "a\nb\ncdef\ngh\nijk", 3)
      end
    end
    context "when requested number of lines is equal to actual number of lines" do
      should "return correct string" do
        assert_equal "a\nb\ncdef\ngh\n", subject.send(:truncate_to_maximum_number_of_lines, "a\nb\ncdef\ngh\n", 4)
      end
    end
    context "when requested number of lines is greater than actual number of lines" do
      should "return correct string" do
        assert_equal "a\nb\ncdef\ngh\nijk", subject.send(:truncate_to_maximum_number_of_lines, "a\nb\ncdef\ngh\nijk", 10)
      end
    end
  end
end
