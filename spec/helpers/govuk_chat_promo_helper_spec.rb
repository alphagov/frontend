RSpec.describe GovukChatPromoHelper do
  let(:base_path_with_promo) { described_class::GOVUK_CHAT_PROMO_BASE_PATHS.first }

  describe "#show_govuk_chat_promo?" do
    context "when GOVUK_CHAT_PROMO_ENABLED is not set" do
      it "returns false" do
        ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: nil do
          expect(show_govuk_chat_promo?(base_path_with_promo)).to be false
        end
      end
    end

    context "when GOVUK_CHAT_PROMO_ENABLED is 'true'" do
      it "returns false when base_path not in configuration" do
        ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "true" do
          expect(show_govuk_chat_promo?("/non-matching-path")).to be false
        end
      end

      it "returns true when base_path is in configuration" do
        ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "true" do
          expect(show_govuk_chat_promo?(base_path_with_promo)).to be true
        end
      end
    end
  end
end
