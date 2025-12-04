class HowGovernmentWorks < ContentItem
  def current_prime_minister
    linked("current_prime_minister").first
  end

  def department_counts
    content_store_response.dig("details", "department_counts")
  end

  def ministerial_role_counts
    content_store_response.dig("details", "ministerial_role_counts")
  end

  def lead_paragraph
    I18n.t("formats.how_government_works.lead_paragraph").html_safe
  end

  def reshuffle_in_progress?
    content_store_response.dig("details", "reshuffle_in_progress")
  end
end
