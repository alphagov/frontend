RSpec.describe "LocalesValidation", type: :model do
  it "validates all locale files" do
    checker = RailsTranslationManager::LocaleChecker.new("config/locales/*.yml")

    expect(checker.validate_locales).to be_truthy
  end
end
