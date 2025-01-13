class CorporateInformationPage < ContentItem
  include ContentsList

  def contents_items
    extract_headings_with_ids + extra_headings
  end

private

  def extra_headings
    extra_headings = []
    extra_headings << corporate_information_heading if corporate_information_groups.any?
    extra_headings
  end

  def corporate_information_heading
    heading_text = I18n.t("formats.corporate_information_page.corporate_information")

    {
      text: heading_text,
      id: heading_text.tr(" ", "-").downcase,
    }
  end

  def corporate_information_groups
    content_store_response.dig("details", "corporate_information_groups") || []
  end
end
