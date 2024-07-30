RSpec.describe "Locales Validation" do
  # Stop the checker putting it's jaunty message to stdout
  around(:example) do |ex|
    original_stdout = $stdout
    $stdout = File.open(File::NULL, "w")
    ex.run
    $stdout = original_stdout
  end

  it "validates all locale files" do
    checker = RailsTranslationManager::LocaleChecker.new("config/locales/*.yml")

    expect(checker.validate_locales).to be_truthy
  end
end
