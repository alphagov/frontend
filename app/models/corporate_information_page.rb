class CorporateInformationPage < ContentItem
  include ContentsList

  def organisation_logo(organisation = default_organisation)
    return nil unless organisation && organisation.dig("details", "logo")

    logo = organisation["details"]["logo"]
    logo_component_params = {
      organisation: {
        name: logo["formatted_title"].html_safe,
        url: organisation["base_path"],
        brand: organisation_brand(organisation),
        crest: logo["crest"],
      },
    }

    if logo["image"]
      logo_component_params[:organisation][:image] = {
        url: logo["image"]["url"],
        alt_text: logo["image"]["alt_text"],
      }
    end

    logo_component_params
  end

  def organisation_brand_class(organisation = default_organisation)
    organisation_brand(organisation).present? ? "#{organisation_brand(organisation)}-brand-colour" : nil
  end

  def contents_items
    extract_headings_with_ids + extra_headings
  end

  def default_organisation
    organisation_content_id = content_store_response.dig("details", "organisation")
    organisation = nil

    if organisations.present?
      organisation = organisations.detect { |org| org["content_id"] == organisation_content_id }
    end

    organisation
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

private

  # HACK: Replaces the organisation_brand for executive office organisations.
  # Remove this in the future after migrating organisations to the content store API,
  # and updating them with the correct brand in the actual store.
  def organisation_brand(organisation)
    return unless organisation

    brand = organisation.dig("details", "brand")
    brand = "executive-office" if executive_order_crest?(organisation)
    brand
  end

  def executive_order_crest?(organisation)
    organisation.dig("details", "logo", "crest") == "eo"
  end

  def normalised_group_links(group)
    group["contents"].map { |group_item| normalised_group_item_link(group_item) }.compact
  end

  def normalised_group_item_link(group_item)
    if group_item.is_a?(String)
      group_item_link = corporate_information_page_links.find { |l| l["content_id"] == group_item }
      # it's possible for corporation_information_groups in details and links hashes to be out of sync.
      if group_item_link
        {
          title: group_item_link["title"],
          path: group_item_link["base_path"],
        }
      end
    else
      {
        title: group_item["title"],
        path: group_item["path"] || group_item["url"],
      }
    end
  end

  def corporate_information_page_links
    content_store_response.dig("links", "corporate_information_pages") || []
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
