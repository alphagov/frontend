RSpec.describe StatisticalDataSet do
  it_behaves_like "it has historical government information", "statistical_data_set", "statistical_data_set_political"
  it_behaves_like "it can be withdrawn", "statistical_data_set", "statistical_data_set_withdrawn"
end
