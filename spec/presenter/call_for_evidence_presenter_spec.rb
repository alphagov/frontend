RSpec.describe CallForEvidencePresenter do
  let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "open_call_for_evidence") }
  let(:content_item) { CallForEvidence.new(content_store_response) }
  let(:presenter) { described_class.new(content_item) }

  describe "#closing_date" do
    it "presents a friendly closing date and time" do
      content_item.content_store_response["details"]["closing_date"] = "2016-12-16T16:00:00+00:00"

      expect(presenter.closing_date).to eq("4pm on 16 December 2016")
    end

    it "presents a closing date and time as 11:59am on the day before if the time is 12am" do
      content_item.content_store_response["details"]["closing_date"] = "2016-11-04T00:00:00+00:00"

      expect(presenter.closing_date).to eq("11:59pm on 3 November 2016")
    end
  end

  describe "#on_or_at" do
    it "returns 'on' if the opening time is 12am" do
      content_item.content_store_response["details"]["opening_date"] = "2016-11-04T00:00:00+00:00"

      expect(presenter.on_or_at).to eq("on")
    end

    it "returns 'at' if the opening time is not 12am" do
      content_item.content_store_response["details"]["opening_date"] = "2016-04-16T13:01:57.000+00:00"

      expect(presenter.on_or_at).to eq("at")
    end
  end

  describe "#opens_closes_or_ran" do
    context "when document type is closed_call_for_evidence" do
      let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "closed_call_for_evidence") }

      it "returns ran_from text" do
        expect(presenter.opens_closes_or_ran).to eq("This call for evidence ran from")
      end
    end

    context "when document type is call_for_evidence_outcome" do
      let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "call_for_evidence_outcome") }

      it "returns ran_from text" do
        expect(presenter.opens_closes_or_ran).to eq("This call for evidence ran from")
      end
    end

    context "when document type is open_call_for_evidence" do
      let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "open_call_for_evidence") }

      it "returns closes_at text if document type is open_call_for_evidence" do
        expect(presenter.opens_closes_or_ran).to eq("This call for evidence closes at")
      end
    end

    context "when document type is call_for_evidence" do
      let(:content_store_response) { GovukSchemas::Example.find("call_for_evidence", example_name: "unopened_call_for_evidence") }

      it "returns opens at text if document type is call_for_evidence" do
        expect(presenter.opens_closes_or_ran).to eq("This call for evidence opens at")
      end
    end
  end

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
