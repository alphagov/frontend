RSpec.describe TopicalEventPresenter do
  subject(:topical_even_presenter) { described_class.new(content_item) }

  let(:content_item) { StatisticsAnnouncement.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name: "topical_event") }
end
