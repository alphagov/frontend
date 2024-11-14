RSpec.describe LandingPage::Block::Statistics do
  let(:blocks_hash) do
    {
      "type" => "statistics",
      "title" => "Chart to visually represent data",
      "x_axis_label" => "X Axis",
      "y_axis_label" => "Y Axis",
      "csv_file" => "data_one.csv",
    }
  end

  let(:subject) { described_class.new(blocks_hash, build(:landing_page_with_data_attachments)) }

  before do
    stub_request(:get, "https://www.asset.test.gov.uk/data_one.csv").to_return(status: 200, body: File.read("spec/fixtures/landing_page_statistics_data/data_one.csv"), headers: {})
    stub_request(:get, "https://www.asset.test.gov.uk/data_two.csv").to_return(status: 200, body: File.read("spec/fixtures/landing_page_statistics_data/data_two.csv"), headers: {})
    stub_request(:get, "https://www.asset.test.gov.uk/data_three.csv").to_return(status: 200, body: File.read("spec/fixtures/landing_page_statistics_data/data_three.csv"), headers: {})
    stub_request(:get, "https://www.asset.test.gov.uk/data_four.csv").to_return(status: 200, body: File.read("spec/fixtures/landing_page_statistics_data/data_four.csv"), headers: {})
  end

  describe "#x_axis_keys" do
    it "gets all of the x-axis data points" do
      expected_keys = %w[
        1/6/2013
        1/6/2014
        1/6/2015
        1/6/2016
        1/6/2017
        1/6/2018
        1/6/2019
      ]

      expect(subject.x_axis_keys).to eq(expected_keys)
    end
  end

  describe "#rows" do
    it "gets the rows for one line of data with decimals" do
      expected_rows = [
        {
          label: "Percentage of people being kinder to one and other",
          values: [
            0.5,
            0.6,
            0.7,
            0.5,
            0.6,
            0.7,
            0.55,
          ],
        },
      ]

      expect(subject.rows).to eq(expected_rows)
    end

    it "gets the rows for one line of data with whole numbers" do
      blocks_hash["csv_file"] = "data_three.csv"

      expected_rows = [
        {
          label: "The number of people working smarter not harder",
          values: [
            45_775.0,
            47_518.0,
            50_546.0,
            56_042.0,
            45_768.0,
            34_530.0,
            29_585.0,
          ],
        },
      ]

      expect(subject.rows).to eq(expected_rows)
    end

    it "gets the rows for one line of data when some rows are missing" do
      blocks_hash["csv_file"] = "data_two.csv"

      expected_rows = [
        {
          label: "Percentage of people being kinder to one and other",
          values: [
            0.5,
            0.6,
            0.7,
            0.5,
            0.6,
            0.7,
            0.5,
            nil,
            nil,
            0.5,
            0.6,
          ],
        },
      ]

      expect(subject.rows).to eq(expected_rows)
    end

    it "gets the rows for two lines of data" do
      blocks_hash["csv_file"] = "data_four.csv"

      expected_rows = [
        {
          label: "Generation X",
          values: [10.0, 20.0, 25.0, 30.0],
        },
        {
          label: "Millenials",
          values: [15.0, 25.0, 30.0, 35.0],
        },
      ]

      expect(subject.rows).to eq(expected_rows)
    end
  end
end
