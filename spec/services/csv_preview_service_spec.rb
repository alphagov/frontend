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

    context "with CSV containing CRLF line terminators and header text on multimple lines" do
      let(:csv) { "header 1,\"header 2\nheader2 details\",header 3\r\ncontent 1,content 2,content 3\r\n" }
      let(:parsed_csv) do
        [
          [
            { text: "header 1" },
            { text: "header 2\nheader2 details" },
            { text: "header 3" },
          ],
          [
            { text: "content 1" },
            { text: "content 2" },
            { text: "content 3" },
          ],
        ]
      end

      it "parses the CSV correctly" do
        expect(csv_preview_service.csv_rows.first).to eq(parsed_csv)
      end
    end

    context "with CSV containing empty rows" do
      let(:csv) { "header 1,header 2,header 3\n,,\ncontent 1,content 2,content 3\n" }

      it "parses the CSV correctly" do
        expect(csv_preview_service.csv_rows.first).to eq(parsed_csv)
      end
    end

    context "with CSV containing empty header columns" do
      let(:csv) { "header 1,header 2,header 3,,,,,,,\ncontent 1,content 2,content 3,,,,,,,\n" }

      it "parses the CSV correctly" do
        expect(csv_preview_service.csv_rows.first).to eq(parsed_csv)
      end
    end

    context "with CSV containing empty header columns in the middle" do
      let(:csv) { "header 1,header 2,,header 4,,,,,,,\ncontent 1,content 2,,content 4,,,,,,,\n" }
      let(:parsed_csv) do
        [
          [
            { text: "header 1" },
            { text: "header 2" },
            { text: nil },
            { text: "header 4" },
          ],
          [
            { text: "content 1" },
            { text: "content 2" },
            { text: nil },
            { text: "content 4" },
          ],
        ]
      end

      context "with CSV containing a totally empty header row" do
        let(:csv) { ",,,,,,,,,\ncontent 1,content 2,content 3,,,,,,,\n" }
        let(:parsed_csv) do
          [
            [
              { text: "content 1" }, { text: "content 2" }, { text: "content 3" }, { text: nil }, { text: nil }, { text: nil }, { text: nil }, { text: nil }, { text: nil }, { text: nil }
            ],
          ]
        end

        it "uses the default column count cap of 50" do
          expect(csv_preview_service.csv_rows.first).to eq(parsed_csv)
        end
      end

      it "parses the CSV correctly allowing for missing headers" do
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
end
