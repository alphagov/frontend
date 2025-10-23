RSpec.describe LocaleHelper do
  include described_class


  describe "#content_item_locale" do
    context "when the content item is in english" do
      let(:content_item) { GovukSchemas::Example.find(:publication, example_name: "publication") }

      it "returns en" do
        expect(content_item_locale).to eq("en")
      end
    end

    context "when the content item is not in english" do
      let(:content_item) do
        GovukSchemas::Example.find(:publication, example_name: "publication").tap do |example|
          example["locale"] = "cy"
        end
      end

      it "returns the appropriate code" do
        expect(content_item_locale).to eq("cy")
      end
    end

    context "with no content item" do
      let(:content_item) { nil }

      it "returns en" do
        expect(content_item_locale).to eq("en")
      end
    end
  end

  describe "#native_language_name_for" do
    it "returns the native language name for the given locale" do
      expect(native_language_name_for(:en)).to eq("English")
      expect(native_language_name_for(:cy)).to eq("Cymraeg")
    end
  end

  describe "#translations_for_nav" do
    it "returns translations in a suitable format for the translation nav component" do
      translations = [
        { "locale" => "en", "base_path" => "/" },
        { "locale" => "cy", "base_path" => "/cy" },
      ]

      expect(translations_for_nav(translations)).to eq(
        [
          {
            active: true,
            locale: "en",
            base_path: "/",
            text: "English",
          },
          {
            locale: "cy",
            base_path: "/cy",
            text: "Cymraeg",
          },
        ],
      )
    end
  end

  describe "#t_locale_fallback" do
    it "returns nil if a value of the key is present" do
      expect(t_locale_fallback("formats.statutory_guidance.name", count: 1)).to be_nil
    end

    it "returns default locale for a string with no locale translation" do
      I18n.with_locale(:cy) do
        expect(t_locale_fallback("formats.big_decision.name", count: 1, locale: :cy)).to eq(:en)
      end
    end

    it "returns returns fallback for irrelevant key" do
      I18n.with_locale(:cy) do
        expect(t_locale_fallback("blah", count: 1)).to eq(:en)
      end
    end
  end

  describe "#native_language_name_for" do
    it "returns the native language name for the given locale" do
      expect(native_language_name_for(:en)).to eq("English")
      expect(native_language_name_for(:cy)).to eq("Cymraeg")
    end
  end

  describe "#rtl_attribute" do
    it "returns an empty string for an ltr language" do
      I18n.with_locale(:en) do
        expect(rtl_attribute).to eq("")
      end
    end

    it "returns a direction-rtl class for an rtl language" do
      I18n.with_locale(:ar) do
        expect(rtl_attribute).to eq("direction-rtl")
      end
    end
  end
end
