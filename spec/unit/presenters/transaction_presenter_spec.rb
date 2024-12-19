RSpec.describe TransactionPresenter do
  def subject(content_item)
    described_class.new(content_item)
  end

  let(:content_store_response) { GovukSchemas::Example.find("transaction", example_name: "transaction") }

  context "start_button_text is 'Start now'" do
    describe "#start_button_text" do
      it "shows the start_button_text" do
        content_store_response["details"]["start_button_text"] = "Start now"
        content_item = Transaction.new(content_store_response)
        expect(subject(content_item).start_button_text).to eq("Start now")
      end
    end
  end

  context "start_button_text is 'Sign in'" do
    describe "#start_button_text" do
      it "shows the custom start button text" do
        content_store_response["details"]["start_button_text"] = "Sign in"
        content_item = Transaction.new(content_store_response)
        expect(subject(content_item).start_button_text).to eq("Sign in")
      end
    end
  end

  context "locale is 'cy'" do
    before { I18n.locale = :cy }
    after { I18n.locale = :en }

    context "start_button_text is 'Start now'" do
      it "returns Welsh translation 'Dechrau nawr'" do
        content_store_response["details"]["start_button_text"] = "Start now"
        content_item = Transaction.new(content_store_response)

        expect(subject(content_item).start_button_text).to eq("Dechrau nawr")
      end
    end

    context "start_button_text is 'Sign in'" do
      it "returns Welsh translation 'Mewngofnodi'" do
        content_store_response["details"]["start_button_text"] = "Sign in"
        content_item = Transaction.new(content_store_response)

        expect(subject(content_item).start_button_text).to eq("Mewngofnodi")
      end
    end
  end
end
