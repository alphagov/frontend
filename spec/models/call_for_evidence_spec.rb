RSpec.describe CallForEvidence do
  let(:open_call_for_evidence) { described_class.new(GovukSchemas::Example.find("call_for_evidence", example_name: "open_call_for_evidence")) }
  let(:open_call_for_evidence_with_participation) { described_class.new(GovukSchemas::Example.find("call_for_evidence", example_name: "open_call_for_evidence_with_participation")) }
  let(:call_for_evidence_outcome_with_featured_attachments) { described_class.new(GovukSchemas::Example.find("call_for_evidence", example_name: "call_for_evidence_outcome_with_featured_attachments")) }
  let(:unopened_call_for_evidence) { described_class.new(GovukSchemas::Example.find("call_for_evidence", example_name: "unopened_call_for_evidence")) }
  let(:closed_call_for_evidence) { described_class.new(GovukSchemas::Example.find("call_for_evidence", example_name: "closed_call_for_evidence")) }
  let(:call_for_evidence_outcome) { described_class.new(GovukSchemas::Example.find("call_for_evidence", example_name: "call_for_evidence_outcome")) }

  it_behaves_like "it can have attachments", "call_for_evidence", "call_for_evidence_outcome_with_featured_attachments"
  it_behaves_like "it can have national applicability", "call_for_evidence", "call_for_evidence_outcome_with_featured_attachments"
  it_behaves_like "it can have people", "call_for_evidence", "open_call_for_evidence"
  it_behaves_like "it has historical government information", "call_for_evidence", "open_call_for_evidence"
  it_behaves_like "it can have single page notifications", "call_for_evidence", "open_call_for_evidence"
  it_behaves_like "it has updates", "call_for_evidence", "open_call_for_evidence"
  it_behaves_like "it can have phases with a running time period", "call_for_evidence", "open_call_for_evidence"
  it_behaves_like "it can have an open phase", "call_for_evidence", "open_call_for_evidence"
  it_behaves_like "it can have a closed phase", "call_for_evidence", "closed_call_for_evidence"
  it_behaves_like "it can have a closed phase", "call_for_evidence", "call_for_evidence_outcome"
  it_behaves_like "it can have an unopened phase", "call_for_evidence", "unopened_call_for_evidence"
  it_behaves_like "it can have an outcome phase", "call_for_evidence", "call_for_evidence_outcome"
  it_behaves_like "it can have ways to respond", "call_for_evidence", "open_call_for_evidence_with_participation"

  describe "#contributors" do
    it "returns a list of organisations" do
      expect(open_call_for_evidence.contributors[0].title).to eq("Office for Health Improvement and Disparities")
      expect(open_call_for_evidence.contributors[0].base_path).to eq("/government/organisations/office-for-health-improvement-and-disparities")
    end

    context "when there are people present" do
      it "returns a list of organisations followed by people" do
        expect(open_call_for_evidence.contributors[1].title).to eq("The Rt Hon Baroness Smith of Malvern")
        expect(open_call_for_evidence.contributors[1].base_path).to eq("/government/people/jacqui-smith")
      end
    end

    describe "#outcome_detail" do
      it "returns information if it has the call_for_evidence_outcome document type" do
        expect(call_for_evidence_outcome.outcome_detail).to be(call_for_evidence_outcome.content_store_response.dig("details", "outcome_detail"))
      end

      it "does not return information if it does not have the call_for_evidence_outcome document type" do
        expect(unopened_call_for_evidence.outcome_detail).not_to be_present
        expect(open_call_for_evidence.outcome_detail).not_to be_present
        expect(closed_call_for_evidence.outcome_detail).not_to be_present
      end
    end

    describe "#outcome_documents" do
      it "returns documents if it has the call_for_evidence_outcome document type" do
        expect(call_for_evidence_outcome_with_featured_attachments.outcome_documents.length).to be(2)
      end

      it "does not return documents if it does not have the call_for_evidence_outcome document type" do
        expect(unopened_call_for_evidence.outcome_documents).to be_empty
        expect(open_call_for_evidence.outcome_documents).to be_empty
        expect(closed_call_for_evidence.outcome_documents).to be_empty
      end
    end

    describe "#attachments_with_details" do
      it "returns the number of attachments that are not accessible" do
        expect(call_for_evidence_outcome_with_featured_attachments.attachments_with_details.count).to eq(3)
      end
    end

    describe "#response_form?" do
      it "returns true for an open_call_for_evidence document type that has attachment url and only email" do
        ways_to_respond = open_call_for_evidence_with_participation.content_store_response.dig("details", "ways_to_respond")
        ways_to_respond.delete("postal_adress")

        expect(open_call_for_evidence_with_participation.response_form?).to be(true)
      end

      it "returns true for an open_call_for_evidence document type that has attachment url and only postal address" do
        ways_to_respond = open_call_for_evidence_with_participation.content_store_response.dig("details", "ways_to_respond")
        ways_to_respond.delete("email")

        expect(open_call_for_evidence_with_participation.response_form?).to be(true)
      end

      it "returns false for an open_call_for_evidence document type that has attachment url but no email or postal address" do
        ways_to_respond = open_call_for_evidence_with_participation.content_store_response.dig("details", "ways_to_respond")
        ways_to_respond.delete("email")
        ways_to_respond.delete("postal_address")

        expect(open_call_for_evidence_with_participation.response_form?).to be(false)
      end
    end

    it "does not have a lead paragraph" do
      expect(open_call_for_evidence.lead_paragraph).to be(false)
    end
  end
end
