class Transaction < ContentItem
  attr_reader :start_button_text, :variant_slug, :variants

  def initialize(content_store_response)
    super(content_store_response)

    @start_button_text = content_store_response.dig("details", "start_button_text")
    @variants = content_store_response.dig("details", "variants")
  end

  def department_analytics_profile
    @department_analytics_profile ||= begin
      if variants.present?
        variant_value = variant_value("department_analytics_profile")
        return variant_value if variant_value.present?
      end

      content_store_response.dig("details", "department_analytics_profile")
    end
  end

  def downtime_message
    if variants.present?
      variant_value = variant_value("downtime_message")
      return variant_value if variant_value.present?
    end

    content_store_response.dig("details", "downtime_message")
  end

  def introductory_paragraph
    if variants.present?
      variant_value = variant_value("introductory_paragraph")
      return variant_value if variant_value.present?
    end

    content_store_response.dig("details", "introductory_paragraph")
  end

  def more_information
    if variants.present?
      variant_value = variant_value("more_information")
      return variant_value if variant_value.present?
    end

    content_store_response.dig("details", "more_information")
  end

  def other_ways_to_apply
    if variants.present?
      variant_value = variant_value("other_ways_to_apply")
      return variant_value if variant_value.present?
    end

    content_store_response.dig("details", "other_ways_to_apply")
  end

  def title
    @title ||= begin
      if variants.present?
        variant_value = variant_value("title")
        return variant_value if variant_value.present?
      end

      content_store_response["title"]
    end
  end

  def transaction_start_link
    if variants.present?
      variant_value = variant_value("transaction_start_link")
      return variant_value if variant_value.present?
    end

    content_store_response.dig("details", "transaction_start_link")
  end

  def what_you_need_to_know
    if variants.present?
      variant_value = variant("what_you_need_to_know")
      return variant_value if variant_value.present?
    end

    content_store_response.dig("details", "what_you_need_to_know")
  end

  def will_continue_on
    if variants.present?
      variant_value = variant("will_continue_on")
      return variant_value if variant_value.present?
    end

    content_store_response.dig("details", "will_continue_on")
  end

  def set_variant(slug)
    @variant_slug = slug
  end

private

  def variant_value(key)
    return if variants.blank?

    selected_variant.fetch(key, nil) if selected_variant.present?
  end

  def selected_variant
    @selected_variant ||= variants.find { |v| v["slug"] == variant_slug }
  end
end
