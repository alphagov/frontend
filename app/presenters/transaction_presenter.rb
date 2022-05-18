class TransactionPresenter < ContentItemPresenter
  attr_accessor :variant_slug

  PASS_THROUGH_DETAILS_KEYS = %i[
    introductory_paragraph
    more_information
    other_ways_to_apply
    transaction_start_link
    what_you_need_to_know
    will_continue_on
    department_analytics_profile
    downtime_message
  ].freeze

  PASS_THROUGH_DETAILS_KEYS.each do |key|
    define_method key do
      if @variant_slug.present?
        variant_val = variant_value(key.to_s)
        return variant_val unless variant_val.nil?
      end
      details[key.to_s] if details
    end
  end

  def title
    if @variant_slug.present?
      variant_val = variant_value("title")
      return variant_val unless variant_val.nil?
    end
    content_item["title"]
  end

  def tab_count
    [more_information, what_you_need_to_know, other_ways_to_apply].count(&:present?)
  end

  def multiple_more_information_sections?
    tab_count > 1
  end

  def start_button_text
    unless details && details["start_button_text"].present?
      return I18n.t("formats.start_now")
    end

    case details["start_button_text"]
    when "Start now"
      I18n.t("formats.start_now")
    when "Sign in"
      I18n.t("formats.transaction.sign_in")
    else
      details["start_button_text"]
    end
  end

private

  def variant_value(key)
    return nil if details["variants"].nil?

    selected_variant = variant
    selected_variant.fetch(key, nil) unless selected_variant.nil?
  end

  def variant
    details["variants"].find { |v| v["slug"] == @variant_slug }
  end
end
