RSpec.shared_examples "it has history" do |document_type, example_name|
  subject(:presenter) { described_class.new(content_item, view_context) }

  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }
  let(:view_context) { ApplicationController.new.view_context }
  let(:model_class) { document_type.camelize.constantize }
  let(:content_item) { model_class.new(content_store_response) }

  it "gets the change history" do
    change_history = content_store_response["details"]["change_history"].map do |change|
      {
        display_time: view_context.display_date(change["public_timestamp"]),
        note: change["note"],
        timestamp: change["public_timestamp"],
      }
    end

    expect(presenter.history.count).to eq(change_history.count)
    expect(presenter.history).to include(change_history.first)
    expect(presenter.history).to include(change_history.last)
  end
end
