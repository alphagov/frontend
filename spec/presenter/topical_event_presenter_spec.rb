RSpec.describe TopicalEventPresenter do
  subject(:topical_event_presenter) { described_class.new(content_item) }

  let(:content_item) { TopicalEvent.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name:) }
  let(:example_name) { "topical-event" }

  describe "#impact_header_image" do
    it "returns the header image" do
      expect(topical_event_presenter.impact_header_image[:type]).to eq("header")
    end

    context "when there is no header image" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name:).tap { |example| example["details"]["images"][1]["type"] = "misc" }
      end

      it "returns the logo image" do
        expect(topical_event_presenter.impact_header_image[:type]).to eq("logo")
      end
    end

    context "when there are no header or logo images" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name:).tap { |example| example["details"]["images"] = [] }
      end

      it "returns nil" do
        expect(topical_event_presenter.impact_header_image).to be_nil
      end
    end

    context "when there is only a legacy logo" do
      let(:example_name) { "western-balkans-summit-london-2018" }

      it "returns the legacy logo image" do
        expect(topical_event_presenter.impact_header_image[:type]).to be_nil
      end
    end
  end

  describe "#impact_header_image_type" do
    it "returns header" do
      expect(topical_event_presenter.impact_header_image_type).to eq("header")
    end

    context "when there is no header image" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name:).tap { |example| example["details"]["images"][1]["type"] = "misc" }
      end

      it "returns logo" do
        expect(topical_event_presenter.impact_header_image_type).to eq("logo")
      end
    end

    context "when there is only a legacy logo" do
      let(:example_name) { "western-balkans-summit-london-2018" }

      it "returns logo" do
        expect(topical_event_presenter.impact_header_image_type).to eq("logo")
      end
    end
  end
end
