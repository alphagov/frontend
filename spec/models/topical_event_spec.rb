RSpec.describe TopicalEvent do
  subject(:topical_event) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018") }
end
