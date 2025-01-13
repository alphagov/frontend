class CorporateInformationPage < ContentItem
  include ContentsList

  def contents_items
    extract_headings_with_ids + extra_headings
  end

  def organisation_brand_class
    return unless default_organisation

    "#{default_organisation.brand}-brand-colour"
  end

  def default_organisation
    return if organisations.blank?

    organisation_content_id = content_store_response.dig("details", "organisation")

    @default_organisation ||= organisations.detect { |org| org.content_id == organisation_content_id }
  end

  def corporate_information?
    corporate_information_groups.any?
  end

  def corporate_information
    corporate_information_groups.map do |group|
      {
        title: group["name"],
        id: group["name"].tr(" ", "-").downcase,
        links: normalised_group_links(group),
      }
    end
  end

  def corporate_information_page
    linked("corporate_information_pages")
  end

private

  def normalised_group_links(group)
    group["contents"].map { |group_item| normalised_group_item_link(group_item) }.compact
  end

  def normalised_group_item_link(group_item)
    if group_item.is_a?(String)
      group_item_link = corporate_information_page.find { |l| l.content_id == group_item }
      # it's possible for corporation_information_groups in details and links hashes to be out of sync.
      if group_item_link
        {
          title: group_item_link.title,
          path: group_item_link.base_path,
        }
      end
    else
      {
        title: group_item["title"],
        path: group_item["path"] || group_item["url"],
      }
    end
  end

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
