RSpec.describe WorkingGroupPresenter do
  subject(:working_group_presenter) { described_class.new(content_item) }

  let(:content_item) { WorkingGroup.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("working_group", example_name: "best-practice-group") }

  it_behaves_like "it can have a contents list", "working_group", "long"

  describe "#additional_headers" do
    it "returns an empty array" do
      expect(working_group_presenter.additional_headers).to eq([])
    end

    context "with contact details present" do
      let(:content_store_response) { GovukSchemas::Example.find("working_group", example_name: "long") }

      it "has a contact details header" do
        expect(working_group_presenter.additional_headers).to include({ "id" => "contact-details", "level" => 2, "text" => "Contact details" })
      end
    end

    context "with policies present" do
      let(:content_store_response) { GovukSchemas::Example.find("working_group", example_name: "with_policies") }

      it "has a policies header" do
        expect(working_group_presenter.additional_headers).to include({ "id" => "policies", "level" => 2, "text" => "Policies" })
      end
    end
  end
end
