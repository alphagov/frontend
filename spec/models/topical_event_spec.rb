RSpec.describe TopicalEvent do
  subject(:topical_event) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018") }

  describe "who's involved initialisation" do
    it "creates an Involved with appropriate settings" do
      expect(FlexiblePage::FlexibleSection::Involved).to receive(:new) do |settings, _|
        expect(settings[:organisations].first).to be_a(Organisation)
        expect(settings[:organisations].first.title).to eq(content_store_response["links"]["organisations"][0]["title"])
      end

      topical_event
    end

    context "when there are no organisations" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["links"]["organisations"] = nil
        end
      end

      it "doesn't create an Involved" do
        expect(FlexiblePage::FlexibleSection::Involved).not_to receive(:new)

        topical_event
      end
    end
  end
end
