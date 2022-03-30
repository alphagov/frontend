require "test_helper"

class LocalesValidationTest < ActiveSupport::TestCase
  test "should validate all locale files" do
    checker = RailsTranslationManager::LocaleChecker.new("config/locales/*.yml", ["formats.transaction"])
    assert checker.validate_locales
  end
end
