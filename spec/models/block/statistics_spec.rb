RSpec.describe Block::Statistics do
  let(:blocks_hash) do
    {
      "type" => "statistics",
      "title" => "Chart to visually represent data",
      "x_axis_label" => "X Axis",
      "y_axis_label" => "Y Axis",
      "csv_file" => "data_one.csv",
      "data_source_link_text" => "Data source",
      "data_source_link" => "https://www.example.com",
    }
  end

  before do
    stub_const("Block::ChartLayout::STATISTICS_DATA_PATH", "spec/fixtures/landing_page_statistics_data")
  end

  describe "statistics content" do
    describe "#title" do
      it "gets statistics title" do
        expect(described_class.new(blocks_hash).title).to eq("Chart to visually represent data")
      end
    end

    describe "#x_axis_label" do
      it "gets the label for the x-axix" do
        expect(described_class.new(blocks_hash).x_axis_label).to eq("X Axis")
      end
    end

    describe "#y_axis_label" do
      it "gets the label for the y-axis" do
        expect(described_class.new(blocks_hash).y_axis_label).to eq("Y Axis")
      end
    end
  end

  describe "chart data" do
    describe "#rows" do
      it "returns the row data for the chart" do
        expected_rows = [
          { "Date" => "2024-01-01", "value" => "10", "variable" => "variable_name" },
          { "Date" => "2024-02-01", "value" => "11", "variable" => "variable_name" },
          { "Date" => "2024-03-01", "value" => "12", "variable" => "variable_name" },
          { "Date" => "2024-04-01", "value" => "13", "variable" => "variable_name" },
          { "Date" => "2024-05-01", "value" => "14", "variable" => "variable_name" },
          { "Date" => "2024-06-01", "value" => "15", "variable" => "variable_name" },
        ]

        expect(described_class.new(blocks_hash).rows).to eq(expected_rows)
      end
    end

    describe "#data_source_link" do
      it "returns the link to the external data source" do
        expect(described_class.new(blocks_hash).data_source_link).to eq("https://www.example.com")
      end
    end
  end
end
