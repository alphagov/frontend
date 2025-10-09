RSpec.shared_examples "it can have phases" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }
end
