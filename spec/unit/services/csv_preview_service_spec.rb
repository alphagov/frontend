RSpec.describe CsvPreviewService do
  before do
    @csv = "header 1,header 2,header 3\ncontent 1,content 2,content 3\n"
    @long_csv = @csv.dup
    (described_class::MAXIMUM_ROWS + 10).times do
      @long_csv = "#{@long_csv}other content 1,other content 2,other content 3\n"
    end
    @crlf_csv = @csv.gsub(/\n/, "\r\n")
    @csv_with_many_columns = "column"
    (described_class::MAXIMUM_COLUMNS + 10).times do
      @csv_with_many_columns = "#{@csv_with_many_columns},column"
    end
    (@csv_with_many_columns << "\n")
    @parsed_csv = [
      [
        { text: "header 1" },
        { text: "header 2" },
        { text: "header 3" },
      ],
      [
        { text: "content 1" },
        { text: "content 2" },
        { text: "content 3" },
      ],
    ]
  end

  describe "#csv_rows" do
    context "with normal CSV" do
      subject { described_class.new(@csv).csv_rows }
      it "parses the CSV correctly" do
        expect(subject.first).to eq(@parsed_csv)
      end

      it "indicates that it is not truncated" do
        expect(subject.second).to be_falsey
      end
    end

    context "with CSV containing CRLF line terminators" do
      subject { described_class.new(@crlf_csv).csv_rows }

      it "parses the CSV correctly" do
        expect(subject.first).to eq(@parsed_csv)
      end
    end

    context "with long CSV" do
      subject { described_class.new(@long_csv).csv_rows }

      it "returns only the header row and less or equal to the maximum number of normal rows" do
        expect(subject.first.length).to be <= (described_class::MAXIMUM_ROWS + 1)
      end

      it "indicates that it is truncated" do
        expect(subject.second).to be_truthy
      end
    end

    context "with CSV containing many columns" do
      subject { described_class.new(@csv_with_many_columns).csv_rows }

      it "returns only less than or equal the maximum number of columns" do
        expect(subject.first.first.length).to be <= described_class::MAXIMUM_COLUMNS
      end

      it "indicates that it is truncated" do
        expect(subject.second).to be_truthy
      end
    end

    context "with CSV in UTF-8" do
      subject do
        described_class.new("za\u017C\u00F3\u0142\u0107 g\u0119\u015Bl\u0105 ja\u017A\u0144\n").csv_rows
      end

      it "parses the CSV correctly" do
        expect(subject.first).to eq([[{ text: "za\u017C\u00F3\u0142\u0107 g\u0119\u015Bl\u0105 ja\u017A\u0144" }]])
      end
    end

    context "with CSV in windows-1252" do
      subject do
        described_class.new("\xFE\xE6r he feoll his tw\xE6gen gebro\xF0ra\n").csv_rows
      end

      it "parses the CSV and convert it to UTF-8" do
        expect(subject.first).to eq([[{ text: "\u00FE\u00E6r he feoll his tw\u00E6gen gebro\u00F0ra" }]])
      end
    end

    context "with CSV with bytes that cannot be converted to UTF-8" do
      subject { described_class.new("F\x8Ed\x8Eration Fran\x8Daise\n") }

      it "raises FileEncodingError" do
        expect { subject.csv_rows }.to raise_error(described_class::FileEncodingError)
      end
    end
  end

  describe "#newline_or_last_char_index" do
    subject { described_class.new("") }

    context "when newline index is less than index of last newline" do
      it "returns the correct index" do
        expect(subject.send(:newline_or_last_char_index, "a\nb\ncdef\ngh\nijk", 2)).to eq(8)
      end
    end

    context "when newline index is equal to index of last newline" do
      it "returns the correct index" do
        expect(subject.send(:newline_or_last_char_index, "a\nb\ncdef\ngh\n", 3)).to eq(11)
      end
    end

    context "when newline index is greater than index of last newline" do
      it "returns the correct index" do
        expect(subject.send(:newline_or_last_char_index, "a\nb\ncdef\ngh\nijk", 10)).to eq(14)
      end
    end
  end

  describe "#truncate_to_maximum_number_of_lines" do
    subject { described_class.new("") }

    context "when requested number of lines is less than actual number of lines" do
      it "returns the correct string" do
        expect(subject.send(:truncate_to_maximum_number_of_lines, "a\nb\ncdef\ngh\nijk", 3)).to eq("a\nb\ncdef\n")
      end
    end

    context "when requested number of lines is equal to actual number of lines" do
      it "returns the correct string" do
        expect(subject.send(:truncate_to_maximum_number_of_lines, "a\nb\ncdef\ngh\n", 4)).to eq("a\nb\ncdef\ngh\n")
      end
    end

    context "when requested number of lines is greater than actual number of lines" do
      it "returns the correct string" do
        expect(subject.send(:truncate_to_maximum_number_of_lines, "a\nb\ncdef\ngh\nijk", 10)).to eq("a\nb\ncdef\ngh\nijk")
      end
    end
  end
end
