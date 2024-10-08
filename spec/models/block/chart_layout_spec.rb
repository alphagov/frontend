RSpec.describe Block::ChartLayout do
  let(:blocks_hash) do
    { 
      "type" => "chart_layout",
      "chart_id" => "chart_one",
      "title" => "Chart to visually represent data",
      "x_axis_label" => "X Axis",
      "y_axis_label" => "Y Axis",
      "csv_file" => "chart_one.csv",
    }
  end

  before do
    stub_const("Block::ChartLayout::CHART_DATA_PATH", "spec/fixtures/landing_page_chart_data")
  end

  describe "chart content" do
    describe "#title" do
      it "gets chart title" do
        expect(described_class.new(blocks_hash).title).to eq("Chart to visually represent data")
      end
    end

    describe  "#x_axis_label" do
      it "gets the label for the x-axix" do
        expect(described_class.new(blocks_hash).x_axis_label).to eq("X Axis")
      end
    end

    describe  "#y_axis_label" do
      it "gets the label for the y-axis" do
        expect(described_class.new(blocks_hash).y_axis_label).to eq("Y Axis")
      end
    end
  end

  describe "chart data" do
    describe "#rows" do
      it "returns the row data for the chart" do
        expected_rows = [
          {"Date"=>"2024-01-01", "value"=>"10", "variable"=>"chart_variable"},
          {"Date"=>"2024-02-01", "value"=>"11", "variable"=>"chart_variable"},
          {"Date"=>"2024-03-01", "value"=>"12", "variable"=>"chart_variable"},
          {"Date"=>"2024-04-01", "value"=>"13", "variable"=>"chart_variable"},
          {"Date"=>"2024-05-01", "value"=>"14", "variable"=>"chart_variable"},
          {"Date"=>"2024-06-01", "value"=>"15", "variable"=>"chart_variable"},
        ]

        expect(described_class.new(blocks_hash).rows).to eq(expected_rows)
      end
    end

    describe "#csv_file_path" do
      it "returns the link to the chart data for a block" do
        expected_path = "/spec/fixtures/landing_page_chart_data/chart_one.csv"
        expect(described_class.new(blocks_hash).csv_file_path).to eq(expected_path)
      end
    end
  end
end