RSpec.describe Block::ChartLayout do
  let(:blocks_hash) do
    { 
      "type" => "chart_layout",
      "chart_id" => "chart_one",
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
end