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
    Block::Statistics.send(:remove_const, "STATISTICS_DATA_PATH")
    Block::Statistics.const_set("STATISTICS_DATA_PATH", "spec/fixtures/landing_page_statistics_data")
  end

  after do
    Block::Statistics.send(:remove_const, "STATISTICS_DATA_PATH")
    Block::Statistics.const_set("STATISTICS_DATA_PATH", "lib/data/landing_page_content_items/statistics")
  end

  describe "#x_axis_keys" do
    it "gets all of the x-axis data points" do
      expected_keys = %w[
        2024-01-01
        2024-02-01
        2024-03-01
        2024-04-01
        2024-05-01
        2024-06-01
      ]

      expect(described_class.new(blocks_hash).x_axis_keys).to eq(expected_keys)
    end

    it "gets all of the unique x-axis data points" do
      expected_keys = %w[
        2024-01-01
        2024-02-01
        2024-03-01
      ]
      blocks_hash["csv_file"] = "data_two.csv"

      expect(described_class.new(blocks_hash).x_axis_keys).to eq(expected_keys)
    end
  end
end
