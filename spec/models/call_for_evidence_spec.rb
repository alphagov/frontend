RSpec.describe CallForEvidence do
  let(:open_call_for_evidence) { described_class.new(GovukSchemas::Example.find("call_for_evidence", example_name: "open_call_for_evidence")) }
  let(:call_for_evidence_outcome_with_featured_attachments) { described_class.new(GovukSchemas::Example.find("call_for_evidence", example_name: "call_for_evidence_outcome_with_featured_attachments")) }
  let(:closed_call_for_evidence) { described_class.new(GovukSchemas::Example.find("call_for_evidence", example_name: "closed_call_for_evidence")) }

  it_behaves_like "it can have attachments", "call_for_evidence", "call_for_evidence_outcome_with_featured_attachments"
  it_behaves_like "it can have national applicability", "call_for_evidence", "call_for_evidence_outcome_with_featured_attachments"
  it_behaves_like "it can have people", "call_for_evidence", "open_call_for_evidence"
  it_behaves_like "it has historical government information", "call_for_evidence", "open_call_for_evidence"
  it_behaves_like "it can have single page notifications", "call_for_evidence", "open_call_for_evidence"
  it_behaves_like "it has updates", "call_for_evidence", "open_call_for_evidence"

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

    describe "#opening_date_time" do
      it "returns the opening date and time" do
        expect(closed_call_for_evidence.opening_date_time).to eq("2022-09-29T14:00:00+01:00")
      end
    end

    describe "#closing_date_time" do
      it "returns the closing date and time" do
        expect(closed_call_for_evidence.closing_date_time).to eq("2022-10-27T17:00:00+01:00")
      end
    end
  end
end
