RSpec.describe StatisticalDataSetPresenter do
  subject(:statistical_data_set_presenter) { described_class.new(content_item) }

  let(:content_item) { StatisticalDataSet.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("statistical_data_set", example_name: "statistical_data_set") }

  describe "#headers_for_contents_list_component" do
    context "with no headers present in the body" do
      let(:content_store_response) { GovukSchemas::Example.find("statistical_data_set", example_name: "statistical_data_set_with_block_attachments") }

      it "returns an empty array" do
        expect(statistical_data_set_presenter.headers_for_contents_list_component).to eq([])
      end
    end

    context "with a body with h2 headers present" do
      it "returns the h2 headers in a format suitable for a Contents List component" do
        expect(statistical_data_set_presenter.headers_for_contents_list_component.count).to eq(6)

        expect(statistical_data_set_presenter.headers_for_contents_list_component[0][:href]).to eq("#olympics")
        expect(statistical_data_set_presenter.headers_for_contents_list_component[0][:text]).to eq("Olympics")
      end

      it "strips the nested headers from the headers for the contents list" do
        expect(statistical_data_set_presenter.headers_for_contents_list_component[0][:items]).to be_empty
      end
    end
  end
end
