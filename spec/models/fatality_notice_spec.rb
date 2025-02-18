RSpec.describe FatalityNotice do
  let(:content_item) { GovukSchemas::Example.find("fatality_notice", example_name: "fatality_notice") }

  describe "#field_of_operation" do
    it "returns the field of operation link structure" do
      model_instance = described_class.new(content_item)

      expect(model_instance.field_of_operation.title).to eq("Zululand")
      expect(model_instance.field_of_operation.path).to eq("/government/fields-of-operation/zululand")
    end

    context "when no field of operation is present" do
      it "returns nil" do
        content_item["links"].delete("field_of_operation")
        model_instance = described_class.new(content_item)

        expect(model_instance.field_of_operation).to be_nil
      end
    end
  end

  describe "#contributors" do
    it "returns the publishing organisation" do
      model_instance = described_class.new(content_item)

      expect(model_instance.contributors.count).to eq(1)
      expect(model_instance.contributors[0]["title"]).to eq("Ministry of Defence")
      expect(model_instance.contributors[0]["base_path"]).to eq("/government/organisations/ministry-of-defence")
    end

    context "when a minister is listed" do
      let(:content_item) { GovukSchemas::Example.find("fatality_notice", example_name: "fatality_notice_with_minister") }

      it "includes the minister" do
        model_instance = described_class.new(content_item)

        expect(model_instance.contributors.count).to eq(2)
        expect(model_instance.contributors[1]["title"]).to eq("The Rt Hon Sir Eric Pickles MP")
        expect(model_instance.contributors[1]["base_path"]).to eq("/government/people/eric-pickles")
      end
    end
  end
end
