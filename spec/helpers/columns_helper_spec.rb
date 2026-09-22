RSpec.describe ColumnsHelper do
  include described_class

  describe "#column_size" do
    it "returns full for 1 column" do
      expect(column_size(1)).to eq("full")
    end

    it "returns one-half for 2 or 4 columns" do
      expect(column_size(2)).to eq("one-half")
      expect(column_size(4)).to eq("one-half")
    end

    it "returns one-third for 3, 5, or above columns" do
      expect(column_size(3)).to eq("one-third")
      expect(column_size(5)).to eq("one-third")
      expect(column_size(6)).to eq("one-third")
      expect(column_size(42)).to eq("one-third")
    end
  end

  describe "#grid_layout_options" do
    it "is large, breaks at 2, full size for 1 column" do
      expect(grid_layout_options(1)).to eq({ class: "govuk-grid-column-full", break_at_column: 2, large: true })
    end

    it "is not large, breaks at 2, one-half size for 2 or 4 columns" do
      expect(grid_layout_options(2)).to eq({ class: "govuk-grid-column-one-half", break_at_column: 2, large: false })
      expect(grid_layout_options(4)).to eq({ class: "govuk-grid-column-one-half", break_at_column: 2, large: false })
    end

    it "is not large, breaks at 3, one-third size for 3, 5, and above columns" do
      expect(grid_layout_options(3)).to eq({ class: "govuk-grid-column-one-third", break_at_column: 3, large: false })
      expect(grid_layout_options(5)).to eq({ class: "govuk-grid-column-one-third", break_at_column: 3, large: false })
      expect(grid_layout_options(6)).to eq({ class: "govuk-grid-column-one-third", break_at_column: 3, large: false })
      expect(grid_layout_options(42)).to eq({ class: "govuk-grid-column-one-third", break_at_column: 3, large: false })
    end
  end
end
