RSpec.describe LandingPage::Block::Statistics do
  let(:blocks_hash) do
    {
      "type" => "statistics",
      "title" => "Chart to visually represent data",
      "x_axis_label" => "X Axis",
      "y_axis_label" => "Y Axis",
      "csv_file" => "data_one.csv",
      "data_source_link" => "https://www.example.com",
    }
  end
  let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }

  before do
    LandingPage::Block::Statistics.send(:remove_const, "STATISTICS_DATA_PATH")
    LandingPage::Block::Statistics.const_set("STATISTICS_DATA_PATH", "spec/fixtures/landing_page_statistics_data")
  end

  after do
    LandingPage::Block::Statistics.send(:remove_const, "STATISTICS_DATA_PATH")
    LandingPage::Block::Statistics.const_set("STATISTICS_DATA_PATH", "lib/data/landing_page_content_items/statistics")
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

      expect(subject.x_axis_keys).to eq(expected_keys)
    end

    it "gets all of the unique x-axis data points" do
      expected_keys = %w[
        2024-01-01
        2024-02-01
        2024-03-01
      ]
      blocks_hash["csv_file"] = "data_two.csv"

      expect(subject.x_axis_keys).to eq(expected_keys)
    end
  end

  describe "#rows" do
    it "gets the rows for one line of data" do
      expected_rows = [
        {
          label: "variable_name",
          values: [10, 11, 12, 13, 14, 15],
        },
      ]

      expect(subject.rows).to eq(expected_rows)
    end

    it "gets the rows for multiple lines of data" do
      expected_rows = [
        {
          label: "variable_name",
          values: [10, 11, 12],
        },
        {
          label: "variable_name_two",
          values: [13, 14, 15],
        },
      ]

      blocks_hash["csv_file"] = "data_two.csv"

      expect(subject.rows).to eq(expected_rows)
    end
  end
end
