RSpec.shared_examples "it can render the govuk_chat promo banner" do |path|
  include Capybara::RSpecMatchers

  context "given the base_path is in the GOVUK_CHAT_PROMO_BASE_PATHS constant" do
    before do
      stub_const("GovukChatPromoHelper::GOVUK_CHAT_PROMO_BASE_PATHS", [path])
    end

    context "and the GOVUK_CHAT_PROMO_ENABLED env var is set to true" do
      it "renders the GOV.UK Chat entry promo banner" do
        ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "true" do
          get path
          expect(response.body).to have_selector(".gem-c-chat-entry")
        end
      end
    end

    context "and the GOVUK_CHAT_PROMO_ENABLED env var is set to false" do
      it "does not render the GOV.UK Chat entry promo banner" do
        ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "false" do
          get path
          expect(response.body).not_to have_selector(".gem-c-chat-entry")
        end
      end
    end

    context "and the GOVUK_CHAT_PROMO_ENABLED env var is not set" do
      it "does not render the GOV.UK Chat entry promo banner" do
        ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: nil do
          get path
          expect(response.body).not_to have_selector(".gem-c-chat-entry")
        end
      end
    end
  end
end
