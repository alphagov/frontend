RSpec.describe WorkingGroupPresenter do
  let(:content_item) { WorkingGroup.new(content_store_response) }

  it_behaves_like "it can have a contents list", "working_group", "long"
end
