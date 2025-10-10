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

    describe "#closed?" do
      it "returns true for closed_call_for_evidence or call_for_evidence_outcome document types" do
        expect(unopened_call_for_evidence.closed?).to be(false)
        expect(open_call_for_evidence.closed?).to be(false)

        expect(closed_call_for_evidence.closed?).to be(true)
        expect(call_for_evidence_outcome.closed?).to be(true)
      end
    end

    describe "#unopened?" do
      it "returns true if it has the 'call_for_evidence' document type" do
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

    describe "#general_documents" do
      it "returns featured attachments if available" do
        expect(call_for_evidence_outcome_with_featured_attachments.general_documents.length).to be(1)
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

    describe "#held_on_another_website_url" do
      it "returns url if it is held on another website" do
        expected_url = open_call_for_evidence.content_store_response.dig("details", "held_on_another_website_url")

        expect(open_call_for_evidence.held_on_another_website_url).to be(expected_url)
      end

      it "does not return url if it is not held on another website" do
        expect(unopened_call_for_evidence.held_on_another_website_url).to be_nil
      end
    end

    describe "#held_on_another_website?" do
      it "returns true if it is held on another website" do
        expect(open_call_for_evidence.held_on_another_website?).to be(true)
      end

      it "returns false if it is not held on another website" do
        expect(unopened_call_for_evidence.held_on_another_website?).to be(false)
      end
    end

    describe "#ways_to_respond?" do
      it "returns true for an open_call_for_evidence document type that has contact information available" do
        expect(open_call_for_evidence_with_participation.ways_to_respond?).to be(true)
      end

      it "returns false for an open_call_for_evidence document type that does not have any contact information available" do
        expect(open_call_for_evidence.ways_to_respond?).to be(false)
      end

      it "returns false for an open_call_for_evidence document type that only has an attachment url as contact information" do
        ways_to_respond = open_call_for_evidence_with_participation.content_store_response.dig("details", "ways_to_respond")
        ways_to_respond.delete("email")
        ways_to_respond.delete("postal_address")
        ways_to_respond.delete("link_url")

        expect(open_call_for_evidence_with_participation.attachment_url).to be_present
        expect(open_call_for_evidence_with_participation.ways_to_respond?).to be(false)
      end

      it "returns false if it does not have the open_call_for_evidence document type" do
        expect(unopened_call_for_evidence.ways_to_respond?).not_to be_present
        expect(closed_call_for_evidence.ways_to_respond?).not_to be_present
        expect(call_for_evidence_outcome.ways_to_respond?).not_to be_present
      end
    end

    describe "#email" do
      it "returns the email address if available" do
        expected_email = open_call_for_evidence_with_participation.content_store_response.dig("details", "ways_to_respond", "email")

        expect(open_call_for_evidence_with_participation.email).to eq(expected_email)
      end

      it "returns nil if email address isn't available" do
        ways_to_respond = open_call_for_evidence_with_participation.content_store_response.dig("details", "ways_to_respond")
        ways_to_respond.delete("email")

        expect(open_call_for_evidence_with_participation.email).to be_nil
      end
    end

    describe "#postal_address" do
      it "returns the postal address if available" do
        expected_postal_address = open_call_for_evidence_with_participation.content_store_response.dig("details", "ways_to_respond", "postal_address")

        expect(open_call_for_evidence_with_participation.postal_address).to eq(expected_postal_address)
      end

      it "returns nil if postal address isn't available" do
        ways_to_respond = open_call_for_evidence_with_participation.content_store_response.dig("details", "ways_to_respond")
        ways_to_respond.delete("postal_address")

        expect(open_call_for_evidence_with_participation.postal_address).to be_nil
      end
    end

    describe "#respond_online_url" do
      it "returns the link url if available" do
        expected_link_url = open_call_for_evidence_with_participation.content_store_response.dig("details", "ways_to_respond", "link_url")

        expect(open_call_for_evidence_with_participation.respond_online_url).to eq(expected_link_url)
      end

      it "returns nil if link url isn't available" do
        ways_to_respond = open_call_for_evidence_with_participation.content_store_response.dig("details", "ways_to_respond")
        ways_to_respond.delete("link_url")

        expect(open_call_for_evidence_with_participation.respond_online_url).to be_nil
      end
    end

    describe "#attachment_url" do
      it "returns the attachment url if available" do
        expected_attachment_url = open_call_for_evidence_with_participation.content_store_response.dig("details", "ways_to_respond", "attachment_url")

        expect(open_call_for_evidence_with_participation.attachment_url).to eq(expected_attachment_url)
      end

      it "returns nil if attachment url isn't available" do
        open_call_for_evidence_with_participation.content_store_response["details"].delete("ways_to_respond")

        expect(open_call_for_evidence_with_participation.attachment_url).to be_nil
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
