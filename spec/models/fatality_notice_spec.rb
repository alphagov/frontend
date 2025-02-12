RSpec.describe FatalityNotice do
  subject(:fatality_notice) { described_class.new(content_item) }

  let(:content_item) { GovukSchemas::Example.find("fatality_notice", example_name: "fatality_notice") }

  it_behaves_like "it has updates", "fatality_notice", "fatality_notice"
  it_behaves_like "it has no updates", "fatality_notice", "fatality_notice_with_minister"

  describe "#field_of_operation" do
    it "returns the field of operation content item" do
      expect(fatality_notice.field_of_operation.title).to eq("Zululand")
      expect(fatality_notice.field_of_operation.base_path).to eq("/government/fields-of-operation/zululand")
    end

    context "when no field of operation is present" do
      it "returns nil" do
        content_item["links"].delete("field_of_operation")

        expect(fatality_notice.field_of_operation).to be_nil
      end
    end
  end

  describe "#contributors" do
    it "returns the publishing organisation" do
      expect(fatality_notice.contributors.count).to eq(1)
      expect(fatality_notice.contributors[0].title).to eq("Ministry of Defence")
      expect(fatality_notice.contributors[0].base_path).to eq("/government/organisations/ministry-of-defence")
    end

    context "when a minister is listed" do
      let(:content_item) { GovukSchemas::Example.find("fatality_notice", example_name: "fatality_notice_with_minister") }

      it "includes the minister" do
        expect(fatality_notice.contributors.count).to eq(2)
        expect(fatality_notice.contributors[1].title).to eq("The Rt Hon Sir Eric Pickles MP")
        expect(fatality_notice.contributors[1].base_path).to eq("/government/people/eric-pickles")
      end
    end
  end
end
