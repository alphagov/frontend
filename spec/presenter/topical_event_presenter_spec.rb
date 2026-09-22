RSpec.describe TopicalEventPresenter do
  subject(:topical_event_presenter) { described_class.new(content_item) }

  let(:content_item) { TopicalEvent.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name:) }
  let(:example_name) { "topical-event" }
end
