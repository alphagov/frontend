RSpec.describe SimpleSmartAnswerPresenter, type: :model do
  def subject(content_item)
    SimpleSmartAnswerPresenter.new(content_item.deep_stringify_keys!)
  end

  context "locale is 'cy'" do
    before { I18n.locale = :cy }
    after { I18n.locale = :en }

    context "start_button_text is 'Start now'" do
      it "returns Welsh translation 'Dechrau nawr'" do
        @item = { details: { start_button_text: "Start now" } }
        expect(subject(@item).start_button_text).to eq("Dechrau nawr")
      end
    end

    context "start_button_text is 'Continue'" do
      it "returns Welsh translation 'Parhau'" do
        @item = { details: { start_button_text: "Continue" } }
        expect(subject(@item).start_button_text).to eq("Parhau")
      end
    end

    context "start_button_text is explicitly set" do
      it "returns the set value" do
        @item = { details: { start_button_text: "Go for it" } }
        expect(subject(@item).start_button_text).to eq("Go for it")
      end
    end
  end
end
