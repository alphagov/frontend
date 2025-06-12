RSpec.describe TravelAdvicePresenter do
  subject(:travel_advice_presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("travel_advice", example_name: "full-country") }
  let(:content_item) { TravelAdvice.new(content_store_response) }

  describe "#page_title" do
    it "includes the title of the current part when there are parts and the current part is not the first part" do
      part_slug = content_store_response.dig("details", "parts").last["slug"]
      content_item.set_current_part(part_slug)

      expect(travel_advice_presenter.page_title).to include(content_item.current_part_title)
      expect(travel_advice_presenter.page_title).to include(content_item.title)
    end

    it "only uses the content item page title when when there are parts and the current part is the first part" do
      part_slug = content_store_response.dig("details", "parts").first["slug"]
      content_item.set_current_part(part_slug)

      expect(travel_advice_presenter.page_title).not_to include(content_item.current_part_title)
      expect(travel_advice_presenter.page_title).to include(content_item.title)
    end

    context "when there aren't any parts" do
      let(:content_store_response) { GovukSchemas::Example.find("travel_advice", example_name: "no-parts") }

      it "only uses the content item page title when there aren't any parts" do
        expect(travel_advice_presenter.page_title).to eq(content_item.title)
      end
    end
  end

  describe "#latest_update" do
    before { content_store_response["details"]["change_description"] = "Latest update: hello!" }

    it "strips Latest update: from change description and capitalises the remainder correctly" do
      expect(travel_advice_presenter.latest_update).to eq("Hello!")
    end

    context "when there isn't an embedded Latest update in the change details string" do
      before { content_store_response["details"]["change_description"] = "hello!" }

      it "capitalises the string" do
        expect(travel_advice_presenter.latest_update).to eq("Hello!")
      end
    end

    context "when there isn't a change description string" do
      before { content_store_response["details"]["change_description"] = "" }

      it "returns the empty string" do
        expect(travel_advice_presenter.latest_update).to eq("")
      end
    end
  end
end
