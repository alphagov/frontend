RSpec.describe SimpleSmartAnswerPresenter do
  def subject(content_item)
    described_class.new(content_item)
  end

  let(:content_store_response) { GovukSchemas::Example.find("simple_smart_answer", example_name: "simple-smart-answer") }

  context "when locale is 'cy'" do
    before { I18n.locale = :cy }
    after { I18n.locale = :en }

    context "and start_button_text is 'Start now'" do
      it "returns Welsh translation 'Dechrau nawr'" do
        content_store_response["details"]["start_button_text"] = "Start now"
        content_item = SimpleSmartAnswer.new(content_store_response)

        expect(subject(content_item).start_button_text).to eq("Dechrau nawr")
      end
    end

    context "and start_button_text is 'Continue'" do
      it "returns Welsh translation 'Parhau'" do
        content_store_response["details"]["start_button_text"] = "Continue"
        content_item = SimpleSmartAnswer.new(content_store_response)

        expect(subject(content_item).start_button_text).to eq("Parhau")
      end
    end

    context "and start_button_text is explicitly set" do
      it "returns the set value" do
        content_store_response["details"]["start_button_text"] = "Go for it"
        content_item = SimpleSmartAnswer.new(content_store_response)

        expect(subject(content_item).start_button_text).to eq("Go for it")
      end
    end
  end
end
