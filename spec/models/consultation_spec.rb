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

  describe "#held_on_another_website_url" do
    it "returns url if it is held on another website" do
      expected_url = open_consultation.content_store_response.dig("details", "held_on_another_website_url")

      expect(open_consultation.held_on_another_website_url).to be(expected_url)
    end

    it "does not return url if it is not held on another website" do
      expect(unopened_consultation.held_on_another_website_url).to be_nil
    end
  end

  describe "#held_on_another_website?" do
    it "returns true if it is held on another website" do
      expect(open_consultation.held_on_another_website?).to be(true)
    end

    it "returns false if it is not held on another website" do
      expect(unopened_consultation.held_on_another_website?).to be(false)
    end
  end

  describe "#email" do
    it "returns the email address if available" do
      expected_email = open_consultation_with_participation.content_store_response.dig("details", "ways_to_respond", "email")

      expect(open_consultation_with_participation.email).to eq(expected_email)
    end

    it "returns nil if email address isn't available" do
      ways_to_respond = open_consultation_with_participation.content_store_response.dig("details", "ways_to_respond")
      ways_to_respond.delete("email")

      expect(open_consultation_with_participation.email).to be_nil
    end
  end

  describe "#postal_address" do
    it "returns the postal address if available" do
      expected_postal_address = open_consultation_with_participation.content_store_response.dig("details", "ways_to_respond", "postal_address")

      expect(open_consultation_with_participation.postal_address).to eq(expected_postal_address)
    end

    it "returns nil if postal address isn't available" do
      ways_to_respond = open_consultation_with_participation.content_store_response.dig("details", "ways_to_respond")
      ways_to_respond.delete("postal_address")

      expect(open_consultation_with_participation.postal_address).to be_nil
    end
  end

  describe "#respond_online_url" do
    it "returns the link url if available" do
      expected_link_url = open_consultation_with_participation.content_store_response.dig("details", "ways_to_respond", "link_url")

      expect(open_consultation_with_participation.respond_online_url).to eq(expected_link_url)
    end

    it "returns nil if link url isn't available" do
      ways_to_respond = open_consultation_with_participation.content_store_response.dig("details", "ways_to_respond")
      ways_to_respond.delete("link_url")

      expect(open_consultation_with_participation.respond_online_url).to be_nil
    end
  end

  describe "#attachment_url" do
    it "returns the attachment url if available" do
      expected_attachment_url = open_consultation_with_participation.content_store_response.dig("details", "ways_to_respond", "attachment_url")

      expect(open_consultation_with_participation.attachment_url).to eq(expected_attachment_url)
    end

    it "returns nil if attachment url isn't available" do
      ways_to_respond = open_consultation_with_participation.content_store_response.dig("details", "ways_to_respond")
      ways_to_respond.delete("attachment_url")

      expect(open_consultation_with_participation.attachment_url).to be_nil
    end

    it "returns nil if ways_to_respond isn't available" do
      ways_to_respond = open_consultation_with_participation.content_store_response["details"]
      ways_to_respond.delete("ways_to_respond")

      expect(open_consultation_with_participation.attachment_url).to be_nil
    end
  end

  describe "#ways_to_respond?" do
    it "returns true for an open_consultation_document type that has contact information available" do
      expect(open_consultation_with_participation.ways_to_respond?).to be(true)
    end

    it "returns false for an open_consultation_document type that does not have any contact information available" do
      expect(open_consultation.ways_to_respond?).to be(false)
    end

    it "returns false for an open_consultation_document type that only has an attachment url as contact information" do
      ways_to_respond = open_consultation_with_participation.content_store_response.dig("details", "ways_to_respond")
      ways_to_respond.delete("email")
      ways_to_respond.delete("postal_address")
      ways_to_respond.delete("link_url")

      expect(open_consultation_with_participation.attachment_url).to be_present
      expect(open_consultation_with_participation.ways_to_respond?).to be(false)
    end

    it "returns false if it does not have the open_consultation_document type" do
      expect(unopened_consultation.ways_to_respond?).not_to be_present
      expect(closed_consultation.ways_to_respond?).not_to be_present
      expect(consultation_outcome.ways_to_respond?).not_to be_present
    end
  end

  describe "#response_form?" do
    it "returns true for an open_consultation document type that has attachment url and only email" do
      ways_to_respond = open_consultation_with_participation.content_store_response.dig("details", "ways_to_respond")
      ways_to_respond.delete("postal_adress")

      expect(open_consultation_with_participation.response_form?).to be(true)
    end

    it "returns true for an open_consultation document type that has attachment url and only postal address" do
      ways_to_respond = open_consultation_with_participation.content_store_response.dig("details", "ways_to_respond")
      ways_to_respond.delete("email")

      expect(open_consultation_with_participation.response_form?).to be(true)
    end

    it "returns false for an open_consultation document type that has attachment url but no email or postal address" do
      ways_to_respond = open_consultation_with_participation.content_store_response.dig("details", "ways_to_respond")
      ways_to_respond.delete("email")
      ways_to_respond.delete("postal_address")

      expect(open_consultation_with_participation.response_form?).to be(false)
    end
  end
end
