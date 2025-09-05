RSpec.describe Consultation do
  let(:withdrawn_consultation) { described_class.new(GovukSchemas::Example.find("consultation", example_name: "consultation_withdrawn")) }

  it_behaves_like "it can be withdrawn", "consultation", "consultation_withdrawn"
  it_behaves_like "it can have attachments", "consultation", "consultation_outcome_with_featured_attachments"
  it_behaves_like "it can have national applicability", "consultation", "consultation_outcome_with_featured_attachments"
  it_behaves_like "it can have people", "consultation", "consultation_withdrawn"

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
end
