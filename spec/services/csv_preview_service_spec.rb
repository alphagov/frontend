RSpec.describe CsvPreviewService do
  subject(:csv_preview_service) { described_class.new(csv) }

  let(:csv) { "header 1,header 2,header 3\ncontent 1,content 2,content 3\n" }

  let(:parsed_csv) do
    [
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
      it "parses the CSV correctly" do
        expect(csv_preview_service.csv_rows.first).to eq(parsed_csv)
      end

      it "indicates that it is not truncated" do
        expect(csv_preview_service.csv_rows.second).to be_falsey
      end
    end

    context "with CSV containing CRLF line terminators" do
      let(:csv) { "header 1,header 2,header 3\r\ncontent 1,content 2,content 3\r\n" }

      it "parses the CSV correctly" do
        expect(csv_preview_service.csv_rows.first).to eq(parsed_csv)
      end
    end

    context "with long CSV" do
      let(:csv) do
        val = "header 1,header 2,header 3\ncontent 1,content 2,content 3\n"
        (described_class::MAXIMUM_ROWS + 10).times do
          val += "other content 1,other content 2,other content 3\n"
        end
        val
      end

      it "returns only the header row and less or equal to the maximum number of normal rows" do
        expect(csv_preview_service.csv_rows.first.length).to be <= (described_class::MAXIMUM_ROWS + 1)
      end

      it "indicates that it is truncated" do
        expect(csv_preview_service.csv_rows.second).to be_truthy
      end
    end

    context "with CSV containing many columns" do
      let(:csv) do
        val = "column"
        (described_class::MAXIMUM_COLUMNS + 10).times do
          val += ",column"
        end
        val += "\n"
      end

      it "returns only less than or equal the maximum number of columns" do
        expect(csv_preview_service.csv_rows.first.first.length).to be <= described_class::MAXIMUM_COLUMNS
      end

      it "indicates that it is truncated" do
        expect(csv_preview_service.csv_rows.second).to be_truthy
      end
    end

    context "with CSV in UTF-8" do
      let(:csv) { "za\u017C\u00F3\u0142\u0107 g\u0119\u015Bl\u0105 ja\u017A\u0144\n" }

      it "parses the CSV correctly" do
        expect(csv_preview_service.csv_rows.first).to eq([[{ text: "za\u017C\u00F3\u0142\u0107 g\u0119\u015Bl\u0105 ja\u017A\u0144" }]])
      end
    end

    context "with CSV in windows-1252" do
      let(:csv) { "\xFE\xE6r he feoll his tw\xE6gen gebro\xF0ra\n" }

      it "parses the CSV and convert it to UTF-8" do
        expect(csv_preview_service.csv_rows.first).to eq([[{ text: "\u00FE\u00E6r he feoll his tw\u00E6gen gebro\u00F0ra" }]])
      end
    end

    context "with CSV with bytes that cannot be converted to UTF-8" do
      let(:csv) { "F\x8Ed\x8Eration Fran\x8Daise\n" }

      it "raises FileEncodingError" do
        expect { csv_preview_service.csv_rows }.to raise_error(described_class::FileEncodingError)
      end
    end
  end

  describe "#newline_or_last_char_index" do
    let(:csv) { "" }

    context "when newline index is less than index of last newline" do
      it "returns the correct index" do
        expect(csv_preview_service.send(:newline_or_last_char_index, "a\nb\ncdef\ngh\nijk", 2)).to eq(8)
      end
    end

    context "when newline index is equal to index of last newline" do
      it "returns the correct index" do
        expect(csv_preview_service.send(:newline_or_last_char_index, "a\nb\ncdef\ngh\n", 3)).to eq(11)
      end
    end

    context "when newline index is greater than index of last newline" do
      it "returns the correct index" do
        expect(csv_preview_service.send(:newline_or_last_char_index, "a\nb\ncdef\ngh\nijk", 10)).to eq(14)
      end
    end
  end

  describe "#truncate_to_maximum_number_of_lines" do
    let(:csv) { "" }

    context "when requested number of lines is less than actual number of lines" do
      it "returns the correct string" do
        expect(csv_preview_service.send(:truncate_to_maximum_number_of_lines, "a\nb\ncdef\ngh\nijk", 3)).to eq("a\nb\ncdef\n")
      end
    end

    context "when requested number of lines is equal to actual number of lines" do
      it "returns the correct string" do
        expect(csv_preview_service.send(:truncate_to_maximum_number_of_lines, "a\nb\ncdef\ngh\n", 4)).to eq("a\nb\ncdef\ngh\n")
      end
    end

    context "when requested number of lines is greater than actual number of lines" do
      it "returns the correct string" do
        expect(csv_preview_service.send(:truncate_to_maximum_number_of_lines, "a\nb\ncdef\ngh\nijk", 10)).to eq("a\nb\ncdef\ngh\nijk")
      end
    end
  end
end
