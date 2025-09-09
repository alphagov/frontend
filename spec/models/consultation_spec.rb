RSpec.describe Consultation do
  let(:withdrawn_consultation) { described_class.new(GovukSchemas::Example.find("consultation", example_name: "consultation_withdrawn")) }
  let(:unopened_consultation) { described_class.new(GovukSchemas::Example.find("consultation", example_name: "unopened_consultation")) }
  let(:open_consultation) { described_class.new(GovukSchemas::Example.find("consultation", example_name: "open_consultation")) }
  let(:closed_consultation) { described_class.new(GovukSchemas::Example.find("consultation", example_name: "closed_consultation")) }
  let(:consultation_outcome) { described_class.new(GovukSchemas::Example.find("consultation", example_name: "consultation_outcome")) }
  let(:consultation_outcome_with_featured_attachments) { described_class.new(GovukSchemas::Example.find("consultation", example_name: "consultation_outcome_with_featured_attachments")) }

  let(:test_documents) do
    [
      { "id" => "01" },
      { "id" => "02" },
      { "id" => "03" },
    ]
  end

  it_behaves_like "it can be withdrawn", "consultation", "consultation_withdrawn"
  it_behaves_like "it can have attachments", "consultation", "consultation_outcome_with_featured_attachments"
  it_behaves_like "it can have national applicability", "consultation", "consultation_outcome_with_featured_attachments"
  it_behaves_like "it can have people", "consultation", "consultation_withdrawn"
  it_behaves_like "it has historical government information", "consultation", "open_consultation"
  it_behaves_like "it can have single page notifications", "consultation", "open_consultation"
  it_behaves_like "it has updates", "consultation", "open_consultation"

  describe "#contributors" do
    it "returns a list of organisations" do
      expect(withdrawn_consultation.contributors[0].title).to eq("Department for Education")
      expect(withdrawn_consultation.contributors[0].base_path).to eq("/government/organisations/department-for-education")
    end

    context "when there are people present" do
      it "returns a list of organisations followed by people" do
        expect(withdrawn_consultation.contributors[1].title).to eq("The Rt Hon Baroness Smith of Malvern")
        expect(withdrawn_consultation.contributors[1].base_path).to eq("/government/people/jacqui-smith")
      end
    end
  end

  describe "#opening_date_time" do
    it "returns the opening date and time" do
      expect(closed_consultation.opening_date_time).to eq("2016-09-05T14:00:00+01:00")
    end
  end

  describe "#closing_date_time" do
    it "returns the closing date and time" do
      expect(closed_consultation.closing_date_time).to eq("2016-10-31T17:00:00+01:00")
    end
  end

  describe "#open?" do
    it "returns true for an open_consultation document type" do
      expect(open_consultation.open?).to be(true)
    end

    it "returns false if it is not an open_consultation document type" do
      expect(unopened_consultation.open?).to be(false)
      expect(closed_consultation.open?).to be(false)
      expect(consultation_outcome.open?).to be(false)
    end
  end

  describe "#closed?" do
    it "returns true for closed_consultation or consultation_outcome document types" do
      expect(unopened_consultation.closed?).to be(false)
      expect(open_consultation.closed?).to be(false)

      expect(closed_consultation.closed?).to be(true)
      expect(consultation_outcome.closed?).to be(true)
    end
  end

  describe "#unopened?" do
    it "returns true if it has the unopened_consultation document type" do
      expect(unopened_consultation.unopened?).to be(true)

      expect(open_consultation.unopened?).to be(false)
      expect(closed_consultation.unopened?).to be(false)
      expect(consultation_outcome.unopened?).to be(false)
    end
  end

  describe "#final_outcome?" do
    it "returns true for a consultation_outcome document type" do
      expect(consultation_outcome.final_outcome?).to be(true)
    end

    it "returns false if it does not have the consultation_outcome document type" do
      expect(unopened_consultation.final_outcome?).to be(false)
      expect(open_consultation.final_outcome?).to be(false)
      expect(closed_consultation.final_outcome?).to be(false)
    end
  end

  describe "#pending_final_outcome?" do
    it "returns true for a closed_consultation document type" do
      expect(closed_consultation.pending_final_outcome?).to be(true)
    end

    it "returns false if it does not have the closed_consultation document type" do
      expect(unopened_consultation.pending_final_outcome?).to be(false)
      expect(open_consultation.pending_final_outcome?).to be(false)
      expect(consultation_outcome.pending_final_outcome?).to be(false)
    end
  end

  describe "#final_outcome_detail" do
    it "returns information if it has the consultation_outcome document type" do
      expected_outcome_detail = consultation_outcome.content_store_response.dig("details", "final_outcome_detail")

      expect(consultation_outcome.final_outcome_detail).to eq(expected_outcome_detail)
    end

    it "does not return information if it does not have the consultation_outcome document type" do
      expect(unopened_consultation.final_outcome_detail).not_to be_present
      expect(open_consultation.final_outcome_detail).not_to be_present
      expect(closed_consultation.final_outcome_detail).not_to be_present
    end
  end

  describe "#final_outcome_attachments_for_components" do
    it "returns final outcome documents if available" do
      consultation_outcome_with_featured_attachments.content_store_response["details"]["attachments"] = test_documents
      consultation_outcome_with_featured_attachments.content_store_response["details"]["final_outcome_attachments"] = %w[02 03]

      expect(consultation_outcome_with_featured_attachments.final_outcome_attachments_for_components.length).to eq(2)
      expect(consultation_outcome_with_featured_attachments.final_outcome_attachments_for_components[0]["id"]).to eq("02")
      expect(consultation_outcome_with_featured_attachments.final_outcome_attachments_for_components[1]["id"]).to eq("03")
    end

    it "does not return information if it does not have the consultation_outcome document type" do
      expect(unopened_consultation.public_feedback_attachments_for_components).not_to be_present
      expect(open_consultation.public_feedback_attachments_for_components).not_to be_present
      expect(closed_consultation.public_feedback_attachments_for_components).not_to be_present
    end
  end

  describe "#public_feedback_attachments_for_components" do
    it "returns public feedback documents" do
      consultation_outcome_with_featured_attachments.content_store_response["details"]["attachments"] = test_documents
      consultation_outcome_with_featured_attachments.content_store_response["details"]["public_feedback_attachments"] = %w[01 03]

      expect(consultation_outcome_with_featured_attachments.public_feedback_attachments_for_components.length).to eq(2)
      expect(consultation_outcome_with_featured_attachments.public_feedback_attachments_for_components[0]["id"]).to eq("01")
      expect(consultation_outcome_with_featured_attachments.public_feedback_attachments_for_components[1]["id"]).to eq("03")
    end

    it "does not return information if it does not have the consultation_outcome document type" do
      expect(unopened_consultation.public_feedback_attachments_for_components).not_to be_present
      expect(open_consultation.public_feedback_attachments_for_components).not_to be_present
      expect(closed_consultation.public_feedback_attachments_for_components).not_to be_present
    end
  end

  describe "#documents_attachments_for_components" do
    it "returns consultation documents if available" do
      closed_consultation.content_store_response["details"]["attachments"] = test_documents
      closed_consultation.content_store_response["details"]["featured_attachments"] = %w[01 02]

      expect(closed_consultation.documents_attachments_for_components.length).to eq(2)
      expect(closed_consultation.documents_attachments_for_components[0]["id"]).to eq("01")
      expect(closed_consultation.documents_attachments_for_components[1]["id"]).to eq("02")
    end
  end
end
