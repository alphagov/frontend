class Transaction < ContentItem
  attr_reader :start_button_text, :variant_slug, :variants

  def initialize(content_store_response)
    super

    @start_button_text = content_store_response.dig("details", "start_button_text")
    @variants = content_store_response.dig("details", "variants")
  end

  def department_analytics_profile
    @department_analytics_profile ||= variant_or_default("department_analytics_profile")
  end

  def downtime_message
    @downtime_message ||= variant_or_default("downtime_message")
  end

  def introductory_paragraph
    @introductory_paragraph ||= variant_or_default("introductory_paragraph")
  end

  def more_information
    @more_information ||= variant_or_default("more_information")
  end

  def other_ways_to_apply
    @other_ways_to_apply ||= variant_or_default("other_ways_to_apply")
  end

  def title
    variant_value("title") || super
  end

  def transaction_start_link
    @transaction_start_link ||= variant_or_default("transaction_start_link")
  end

  def what_you_need_to_know
    @what_you_need_to_know ||= variant_or_default("what_you_need_to_know")
  end

  def will_continue_on
    @will_continue_on ||= variant_or_default("will_continue_on")
  end

  def set_variant(slug)
    @variant_slug = slug
  end

  def multiple_more_information_sections?
    section_count > 1
  end

private

  def section_count
    [more_information, what_you_need_to_know, other_ways_to_apply].count(&:present?)
  end

  def variant_or_default(key)
    variant_value(key) || content_store_response.dig("details", key)
  end

  def variant_value(key)
    return if variants.blank?

    selected_variant.fetch(key, nil) if selected_variant.present?
  end

  def selected_variant
    @selected_variant ||= variants.find { |v| v["slug"] == variant_slug }
  end
end
