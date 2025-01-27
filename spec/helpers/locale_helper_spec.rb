RSpec.describe LocaleHelper do
  include described_class

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
      expect(t_locale_fallback("formats.take_part", count: 1)).to be_nil
    end

    it "returns default locale for a string with no locale translation" do
      I18n.with_locale(:cy) do
        expect(t_locale_fallback("formats.big_decision", count: 1, locale: :cy)).to eq(:en)
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
end
