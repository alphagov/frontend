class TransactionPresenter < ContentItemPresenter
  PASS_THROUGH_DETAILS_KEYS = %i(
    introductory_paragraph
    more_information
    other_ways_to_apply
    transaction_start_link
    what_you_need_to_know
    will_continue_on
    department_analytics_profile
    downtime_message
  ).freeze

  PASS_THROUGH_DETAILS_KEYS.each do |key|
    define_method key do
      details[key.to_s] if details
    end
  end

  NEW_WINDOW_TRANSACTIONS = %w(
    apply-blue-badge
    claim-state-pension-online
    pension-credit-calculator
    report-benefit-fraud
    report-extremism
    pay-court-fine-online
    send-vat-return
    use-construction-industry-scheme-online
    file-your-company-accounts-and-tax-return
    check-mot-status-vehicle
    check-mot-history-vehicle
  ).freeze

  def multiple_more_information_sections?
    [more_information, what_you_need_to_know, other_ways_to_apply].count(&:present?) > 1
  end

  def open_in_new_window?
    slug.in? NEW_WINDOW_TRANSACTIONS
  end

  def start_button_text
    if details && details['start_button_text'].present?
      details['start_button_text']
    else
      I18n.t('formats.transaction.start_now')
    end
  end
end
