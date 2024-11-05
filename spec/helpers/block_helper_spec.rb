RSpec.describe BlockHelper do
  include BlockHelper

  describe "tab_items_to_component_format" do
    let(:tab_items) do
      [
        {
          "id" => "tab-1",
          "label" => "Item 1",
          "content" => "Here's the content for item one",
        },
      ]
    end

    it "wraps content in a govuk style" do
      expect(tab_items_to_component_format(tab_items).first[:content]).to include("govuk-body")
    end
  end

  describe "#column_class_for_equal_columns" do
    it "returns govuk-grid-column when there is one column" do
      expect(column_class_for_equal_columns(1)).to eq("govuk-grid-column")
    end

    it "returns govuk-grid-column-one-half when there is two columns" do
      expect(column_class_for_equal_columns(2)).to eq("govuk-grid-column-one-half")
    end

    it "returns govuk-grid-column-one-third when there is three columns" do
      expect(column_class_for_equal_columns(3)).to eq("govuk-grid-column-one-third")
    end

    it "returns govuk-grid-column-one-quarter when there more than three columns" do
      expect(column_class_for_equal_columns(4)).to eq("govuk-grid-column-one-quarter")
    end
  end

  describe "#column_class_for_assymetric_columns" do
    context "when there are three columns" do
      it "returns govuk-grid-column-one-third when the column size is 1" do
        expect(column_class_for_assymetric_columns(3, 1)).to eq("govuk-grid-column-one-third")
      end

      it "returns govuk-grid-column-two-thirds when the column size is 2" do
        expect(column_class_for_assymetric_columns(3, 2)).to eq("govuk-grid-column-two-thirds-from-desktop")
      end
    end

    context "when there are four columns" do
      it "returns govuk-grid-column-one-quarter when the column size is 1" do
        expect(column_class_for_assymetric_columns(4, 1)).to eq("govuk-grid-column-one-quarter")
      end

      it "returns govuk-grid-column-two-quarters when the column size is 2" do
        expect(column_class_for_assymetric_columns(4, 2)).to eq("govuk-grid-column-two-quarters")
      end

      it "returns govuk-grid-column-three-quarters when the column size is 2" do
        expect(column_class_for_assymetric_columns(4, 3)).to eq("govuk-grid-column-three-quarters")
      end
    end
  end

  describe "#render_block" do
    it "returns an empty string when a partial template doesn't exist" do
      block = double(type: "not_a_block")
      expect(render_block(block)).to be_empty
    end
  end

  describe "#block_image_path" do
    it "returns an image path for a local image" do
      expect(block_image_path("landing_page/placeholder/desktop.png")).to eq("/images/landing_page/placeholder/desktop.png")
    end

    it "returns the original url for a remote image" do
      expect(block_image_path("http://www.gov.uk/favicon.png")).to eq("http://www.gov.uk/favicon.png")
    end
  end
end
