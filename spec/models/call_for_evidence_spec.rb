RSpec.describe CallForEvidence do
  let(:open_call_for_evidence) { described_class.new(GovukSchemas::Example.find("call_for_evidence", example_name: "open_call_for_evidence")) }
  let(:call_for_evidence_outcome_with_featured_attachments) { described_class.new(GovukSchemas::Example.find("call_for_evidence", example_name: "call_for_evidence_outcome_with_featured_attachments")) }
  let(:unopened_call_for_evidence) { described_class.new(GovukSchemas::Example.find("call_for_evidence", example_name: "unopened_call_for_evidence")) }
  let(:closed_call_for_evidence) { described_class.new(GovukSchemas::Example.find("call_for_evidence", example_name: "closed_call_for_evidence")) }
  let(:call_for_evidence_outcome) { described_class.new(GovukSchemas::Example.find("call_for_evidence", example_name: "call_for_evidence_outcome")) }

  it_behaves_like "it can have attachments", "call_for_evidence", "call_for_evidence_outcome_with_featured_attachments"
  it_behaves_like "it can have national applicability", "call_for_evidence", "open_call_for_evidence"
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

    describe "#open?" do
      it "returns true for an open_call_for_evidence document type" do
        expect(open_call_for_evidence.open?).to be(true)
      end

      it "returns false if it is not an open_call_for_evidence document type" do
        expect(unopened_call_for_evidence.open?).to be(false)
        expect(closed_call_for_evidence.open?).to be(false)
        expect(call_for_evidence_outcome.open?).to be(false)
      end
    end

    describe "#closed?" do
      it "returns true for closed_call_for_evidence or call_for_evidence_outcome document types" do
        expect(unopened_call_for_evidence.closed?).to be(false)
        expect(open_call_for_evidence.closed?).to be(false)

        expect(closed_call_for_evidence.closed?).to be(true)
        expect(call_for_evidence_outcome.closed?).to be(true)
      end
    end

    describe "#unopened?" do
      it "returns true if it has the unopened_call_for_evidence document type" do
        expect(unopened_call_for_evidence.unopened?).to be(true)

        expect(open_call_for_evidence.unopened?).to be(false)
        expect(closed_call_for_evidence.unopened?).to be(false)
        expect(call_for_evidence_outcome.unopened?).to be(false)
      end
    end

    describe "#outcome?" do
      it "returns true for an the call_for_evidence_outcome document type" do
        expect(call_for_evidence_outcome.outcome?).to be(true)
      end

      it "returns false if it does not have the call_for_evidence_outcome document type" do
        expect(unopened_call_for_evidence.outcome?).to be(false)
        expect(open_call_for_evidence.outcome?).to be(false)
        expect(closed_call_for_evidence.outcome?).to be(false)
      end
    end
  end
end
