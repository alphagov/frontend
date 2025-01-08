RSpec.describe "Locales Validation" do
  it "validates all locale files" do
    checker = RailsTranslationManager::LocaleChecker.new("config/locales/*.yml")

    expect { checker.validate_locales }.to output("Locale files are in sync, nice job!\n").to_stdout
  end
end
