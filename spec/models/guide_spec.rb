RSpec.describe Guide do
  let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide") }

  it_behaves_like "it has parts", "guide", "guide"
end
