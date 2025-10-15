RSpec.describe CallForEvidencePresenter do
  let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "open_call_for_evidence") }
  let(:content_item) { CallForEvidence.new(content_store_response) }
  let(:presenter) { described_class.new(content_item) }

  describe "#notice_title" do
    context "when document type is call_for_evidence" do
      let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "unopened_call_for_evidence") }

      it "returns not_open_yet text" do
        expect(presenter.notice_title).to eq("This call for evidence isn't open yet")
      end
    end

    context "when document type is call_for_evidence_outcome" do
      let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "call_for_evidence_outcome") }

      it "returns closed text" do
        expect(presenter.notice_title).to eq("This call for evidence has closed")
      end
    end

    context "when document type is closed_call_for_evidence" do
      let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "closed_call_for_evidence") }

      it "returns an empty string" do
        expect(presenter.notice_title).to be_empty
      end
    end

    context "when document type is open_call_for_evidence" do
      let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "open_call_for_evidence") }

      it "returns an empty string" do
        expect(presenter.notice_title).to be_empty
      end
    end
  end

  describe "#notice_description" do
    context "when document type is open_call_for_evidence" do
      let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "open_call_for_evidence") }

      it "returns empty text" do
        expect(presenter.notice_description).to eq("")
      end
    end

    context "when document type is unopened_call_for_evidence" do
      let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "unopened_call_for_evidence") }

      it "returns not_open_yet text" do
        expect(presenter.notice_description).to eq("This call for evidence opens")
      end
    end

    context "when document type is closed_call_for_evidence" do
      let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "closed_call_for_evidence") }

      it "returns empty text" do
        expect(presenter.notice_description).to eq("")
      end
    end

    context "when document type is call_for_evidence_outcome" do
      let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "call_for_evidence_outcome") }

      it "returns empty text" do
        expect(presenter.notice_description).to eq("")
      end
    end
  end
end
