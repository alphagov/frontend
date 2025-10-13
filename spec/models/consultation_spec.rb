RSpec.describe Consultation do
  let(:withdrawn_consultation) { described_class.new(GovukSchemas::Example.find("consultation", example_name: "consultation_withdrawn")) }
  let(:unopened_consultation) { described_class.new(GovukSchemas::Example.find("consultation", example_name: "unopened_consultation")) }
  let(:open_consultation) { described_class.new(GovukSchemas::Example.find("consultation", example_name: "open_consultation")) }
  let(:closed_consultation) { described_class.new(GovukSchemas::Example.find("consultation", example_name: "closed_consultation")) }
  let(:consultation_outcome) { described_class.new(GovukSchemas::Example.find("consultation", example_name: "consultation_outcome")) }
  let(:consultation_outcome_with_featured_attachments) { described_class.new(GovukSchemas::Example.find("consultation", example_name: "consultation_outcome_with_featured_attachments")) }
  let(:open_consultation_with_participation) { described_class.new(GovukSchemas::Example.find("consultation", example_name: "open_consultation_with_participation")) }

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
  it_behaves_like "it can have phases with a running time period", "consultation", "open_consultation"
  it_behaves_like "it can have an open phase", "consultation", "open_consultation"
  it_behaves_like "it can have a closed phase", "consultation", "closed_consultation"
  it_behaves_like "it can have a closed phase", "consultation", "consultation_outcome"
  it_behaves_like "it can have an unopened phase", "consultation", "unopened_consultation"
  it_behaves_like "it can have an outcome phase", "consultation", "consultation_outcome"
  it_behaves_like "it can have ways to respond", "consultation", "open_consultation_with_participation"

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

  describe "#final_outcome_attachments" do
    it "returns final outcome documents if available" do
      consultation_outcome_with_featured_attachments.content_store_response["details"]["attachments"] = test_documents
      consultation_outcome_with_featured_attachments.content_store_response["details"]["final_outcome_attachments"] = %w[02 03]

      expect(consultation_outcome_with_featured_attachments.final_outcome_attachments.length).to eq(2)
      expect(consultation_outcome_with_featured_attachments.final_outcome_attachments[0]["id"]).to eq("02")
      expect(consultation_outcome_with_featured_attachments.final_outcome_attachments[1]["id"]).to eq("03")
    end

    it "does not return information if it does not have the consultation_outcome document type" do
      expect(unopened_consultation.public_feedback_attachments).not_to be_present
      expect(open_consultation.public_feedback_attachments).not_to be_present
      expect(closed_consultation.public_feedback_attachments).not_to be_present
    end
  end

  describe "#public_feedback_attachments" do
    it "returns public feedback documents" do
      consultation_outcome_with_featured_attachments.content_store_response["details"]["attachments"] = test_documents
      consultation_outcome_with_featured_attachments.content_store_response["details"]["public_feedback_attachments"] = %w[01 03]

      expect(consultation_outcome_with_featured_attachments.public_feedback_attachments.length).to eq(2)
      expect(consultation_outcome_with_featured_attachments.public_feedback_attachments[0]["id"]).to eq("01")
      expect(consultation_outcome_with_featured_attachments.public_feedback_attachments[1]["id"]).to eq("03")
    end

    it "does not return information if it does not have the consultation_outcome document type" do
      expect(unopened_consultation.public_feedback_attachments).not_to be_present
      expect(open_consultation.public_feedback_attachments).not_to be_present
      expect(closed_consultation.public_feedback_attachments).not_to be_present
    end
  end

  describe "#attachments_with_details" do
    it "returns the number of attachments that are not accessible" do
      expect(consultation_outcome_with_featured_attachments.attachments_with_details.count).to eq(4)
    end
  end

  describe "#public_feedback_detail" do
    it "returns public feedback detail" do
      expected_detail = consultation_outcome.content_store_response["details"]["public_feedback_detail"]

      expect(consultation_outcome.public_feedback_detail).to eq(expected_detail)
    end

    it "does not return information if it does not have the consultation_outcome document type" do
      expect(unopened_consultation.public_feedback_detail).not_to be_present
      expect(open_consultation.public_feedback_detail).not_to be_present
      expect(closed_consultation.public_feedback_detail).not_to be_present
    end
  end
end
