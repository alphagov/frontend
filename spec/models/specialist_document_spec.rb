RSpec.describe SpecialistDocument do
  context "with links to an external site" do
    let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "business-finance-support-scheme") }

    describe "#continuation_link" do
      it "gets the continuation link" do
        expected_continuation_link = content_store_response["details"]["metadata"]["continuation_link"]
        expect(described_class.new(content_store_response).continuation_link).to eq(expected_continuation_link)
      end
    end

    describe "#will_continue_on" do
      it "gets the continuation link text" do
        expected_will_continue_on = content_store_response["details"]["metadata"]["will_continue_on"]
        expect(described_class.new(content_store_response).will_continue_on).to eq(expected_will_continue_on)
      end
    end
  end
end
