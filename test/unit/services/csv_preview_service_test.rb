require "test_helper"

class CsvPreviewServiceTest < ActiveSupport::TestCase
  setup do
    @csv = <<~CSV
      header 1,header 2,header 3
      content 1,content 2,content 3
    CSV

    @long_csv = @csv.dup
    (CsvPreviewService::MAXIMUM_ROWS + 10).times { @long_csv += "other content 1,other content 2,other content 3\n" }

    @crlf_csv = @csv.gsub(/\n/, "\r\n")

    @csv_with_many_columns = "column"
    (CsvPreviewService::MAXIMUM_COLUMNS + 10).times { @csv_with_many_columns += ",column" }
    @csv_with_many_columns << "\n"

    @parsed_csv = [
      [{ text: "header 1" }, { text: "header 2" }, { text: "header 3" }],
      [{ text: "content 1" }, { text: "content 2" }, { text: "content 3" }],
    ]
  end

  context "#csv_rows" do
    context "with normal CSV" do
      subject { CsvPreviewService.new(@csv).csv_rows }

      should "parse the CSV correctly" do
        assert_equal @parsed_csv, subject.first
      end

      should "indicate that it is not truncated" do
        assert_not subject.second
      end
    end

    context "with CSV containing CRLF line terminators" do
      subject { CsvPreviewService.new(@crlf_csv).csv_rows }

      should "parse the CSV correctly" do
        assert_equal @parsed_csv, subject.first
      end
    end

    context "with long CSV" do
      subject { CsvPreviewService.new(@long_csv).csv_rows }

      should "return only the header row and less or equal to the maximum number of normal rows" do
        assert_operator subject.first.length, :<=, CsvPreviewService::MAXIMUM_ROWS + 1
      end

      should "indicate that it is truncated" do
        assert subject.second
      end
    end

    context "with CSV containing many columns" do
      subject { CsvPreviewService.new(@csv_with_many_columns).csv_rows }

      should "return only less than or equal the maximum number of columns" do
        assert_operator subject.first.first.length, :<=, CsvPreviewService::MAXIMUM_COLUMNS
      end

      should "indicate that it is truncated" do
        assert subject.second
      end
    end

    context "with CSV in UTF-8" do
      subject { CsvPreviewService.new("zażółć gęślą jaźń\n").csv_rows }

      should "parse the CSV correctly" do
        assert_equal [[{ text: "zażółć gęślą jaźń" }]], subject.first
      end
    end

    context "with CSV in windows-1252" do
      subject { CsvPreviewService.new("\xfe\xe6r he feoll his tw\xe6gen gebro\xf0ra\n").csv_rows }

      should "parse the CSV and convert it to UTF-8" do
        assert_equal [[{ text: "þær he feoll his twægen gebroðra" }]], subject.first
      end
    end
  end

  context "#newline_or_last_char_index" do
    subject { CsvPreviewService.new("") }

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
    subject { CsvPreviewService.new("") }

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
