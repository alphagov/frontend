RSpec.describe StatisticalDataSetPresenter do
  subject(:statistical_data_set_presenter) { described_class.new(content_item) }

  let(:content_item) { StatisticalDataSet.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("statistical_data_set", example_name: "statistical_data_set") }

  it_behaves_like "it can have a contents list", "statistical_data_set", "statistical_data_set"
end
