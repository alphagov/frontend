class CorporateInformationPagePresenter < ContentItemPresenter
  include LinkHelper

  def contents_list_headings
    content_item.contents << corporate_information_heading if content_item.corporate_information?
  end

  def corporate_information_heading
    heading_text = I18n.t("formats.corporate_information_page.corporate_information")
    heading_id = heading_text.tr(" ", "-").downcase

    {
      text: heading_text,
      id: heading_id,
      href: "##{heading_id}",
    }
  end

  def further_information
    return unless corporate_information_pages?

    further_information_links
  end

private

  def corporate_information_pages?
    content_item.corporate_information_pages.any?
  end

  def further_information_links
    links = further_information_types.map do |further_information_type|
      page = content_item.corporate_information_pages.find { |content_item| content_item.document_type == further_information_type }
      next unless page

      link = govuk_styled_link(page.title, path: page.base_path)

      I18n.t("formats.corporate_information_page.#{further_information_type}_html", link:)
    end

    links.compact.join(" ").html_safe
  end

  def further_information_types
    %w[
      publication_scheme
      welsh_language_scheme
      personal_information_charter
      social_media_use
      about_our_services
    ]
  end
end
