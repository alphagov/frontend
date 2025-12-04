class HowGovernmentWorks < ContentItem
  def lead_paragraph
    I18n.t("formats.how_government_works.lead_paragraph").html_safe
  end
end
