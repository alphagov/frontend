RSpec.describe HmrcManualSection do
  include ContentStoreHelpers

  subject(:hmrc_manual_section) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("hmrc_manual_section", example_name: "vatgpb2000") }
  let(:manual_content_store_response) { GovukSchemas::Example.find("hmrc_manual", example_name: "vat-government-public-bodies") }

  before do
    stub_content_store_has_item(manual_content_store_response.fetch("base_path"), manual_content_store_response)
  end

  it_behaves_like "it can have section groups", "hmrc_manual_section", "vatgpb2000"

  describe "attributes" do
    it "has a section_id set from the content item" do
      expect(hmrc_manual_section.section_id).to eq("VATGPB2000")
    end

    it "has child_section_groups set from the content item" do
      expect(hmrc_manual_section.child_section_groups).to eq(content_store_response["details"]["child_section_groups"])
    end
  end

  describe "#next_sibling" do
    it "returns the next sibling" do
      expect(hmrc_manual_section.next_sibling).to eq({
        "base_path" => "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb3000",
        "description" => "",
        "section_id" => "VATGPB3000",
        "title" => "Non-business activities: contents",
      })
    end

    context "when there is no next sibling" do
      let(:manual_content_store_response) do
        GovukSchemas::Example.find("hmrc_manual", example_name: "vat-government-public-bodies").tap do |item|
          item["details"]["child_section_groups"].first["child_sections"].slice!(2, 9)
        end
      end

      it "returns nil" do
        expect(hmrc_manual_section.next_sibling).to be_nil
      end
    end

    context "when the parent manual is not a manual" do
      before do
        stub_content_store_has_item(manual_content_store_response.fetch("base_path"), GovukSchemas::Example.find("redirect", example_name: "redirect"))
      end

      it "returns nil" do
        expect(hmrc_manual_section.next_sibling).to be_nil
      end
    end
  end

  describe "#previous_sibling" do
    it "returns the previous sibling" do
      expect(hmrc_manual_section.previous_sibling).to eq({
        "base_path" => "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb1000",
        "description" => "",
        "section_id" => "VATGPB1000",
        "title" => "Introduction: contents",
      })
    end

    context "when there is no previous sibling" do
      let(:manual_content_store_response) do
        GovukSchemas::Example.find("hmrc_manual", example_name: "vat-government-public-bodies").tap do |item|
          item["details"]["child_section_groups"].first["child_sections"].slice!(0, 1)
        end
      end

      it "returns nil" do
        expect(hmrc_manual_section.previous_sibling).to be_nil
      end
    end

    context "when the parent manual is not a manual" do
      before do
        stub_content_store_has_item(manual_content_store_response.fetch("base_path"), GovukSchemas::Example.find("redirect", example_name: "redirect"))
      end

      it "returns nil" do
        expect(hmrc_manual_section.previous_sibling).to be_nil
      end
    end
  end
end
