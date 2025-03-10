class CorporateInformationPagePresenter < ContentItemPresenter
  def initialize(content_item, view_context)
    super(content_item)
    @view_context = view_context
  end

  def corporate_information_heading
    I18n.t("formats.corporate_information_page.corporate_information")
  end

  def corporate_information_heading_id
    corporate_information_heading.tr(" ", "-").downcase
  end

  def further_information
    [
      further_information_about("publication_scheme"),
      further_information_about("welsh_language_scheme"),
      further_information_about("personal_information_charter"),
      further_information_about("social_media_use"),
      further_information_about("about_our_services"),
    ].join(" ").html_safe
  end

private

  def further_information_about(type)
    link = further_information_link(type)
    I18n.t("formats.corporate_information_page.#{type}_html", link:) if link
  end

  def further_information_link(type)
    links = content_item.content_store_response.dig("links", "corporate_information_pages") || []

    link = links.find { |l| l["document_type"] == type }
    @view_context.link_to(link["title"], link["base_path"]) if link
  end
end
