RSpec.describe WorkingGroup do
  subject(:working_group) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("working_group", example_name: "long") }

  describe "#email" do
    context "when an email is present in the details hash" do
      it "returns the email" do
        expect(working_group.email).to eq("communications@btuh.nhs")
      end
    end

    context "when there is no email in the details hash" do
      let(:content_store_response) { GovukSchemas::Example.find("working_group", example_name: "best-practice-group") }

      it "returns a blank string" do
        expect(working_group.email).to be_blank
      end
    end
  end

  describe "#headers" do
    context "when there are headers in the details hash" do
      it "returns a list of headings" do
        expect(working_group.headers).to eq(content_store_response["details"]["headers"])
      end
    end

    context "when there are no headers in the details hash" do
      let(:content_store_response) { GovukSchemas::Example.find("working_group", example_name: "short") }

      it "returns an empty array" do
        expect(working_group.headers).to eq([])
      end
    end
  end

  describe "#policies" do
    context "when there are policy links" do
      let(:content_store_response) { GovukSchemas::Example.find("working_group", example_name: "with_policies") }

      it "returns an an array of policy title/paths" do
        expect(working_group.policies.count).to eq(content_store_response["links"]["policies"].count)
        expect(working_group.policies.first.title).to eq(content_store_response["links"]["policies"][0]["title"])
        expect(working_group.policies.first.base_path).to eq(content_store_response["links"]["policies"][0]["base_path"])
      end
    end

    context "when there are no policy links" do
      it "returns an empty array" do
        expect(working_group.policies).to eq([])
      end
    end
  end
end
