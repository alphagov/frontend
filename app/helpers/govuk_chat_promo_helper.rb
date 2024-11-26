module GovukChatPromoHelper
  GOVUK_CHAT_PROMO_BASE_PATHS = %w[
    /contracts-finder
    /employee-immigration-employment-status
    /file-changes-to-a-company-with-companies-house
    /file-your-company-accounts-and-tax-return
    /file-your-company-annual-accounts
    /file-your-confirmation-statement-with-companies-house
    /find-business-rates
    /legal-right-work-uk
    /send-rent-lease-details
    /use-construction-industry-scheme-online
  ].freeze

  def show_govuk_chat_promo?(base_path)
    ENV["GOVUK_CHAT_PROMO_ENABLED"] == "true" && GOVUK_CHAT_PROMO_BASE_PATHS.include?(base_path)
  end
end
