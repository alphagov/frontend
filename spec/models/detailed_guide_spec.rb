RSpec.describe DetailedGuide do
  let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide") }

  it_behaves_like "it can have single page notifications", "detailed_guide", "detailed_guide"
end
