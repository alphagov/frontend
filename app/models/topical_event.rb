class TopicalEvent < FlexiblePage
  include EmphasisedOrganisations

  def initialize(content_store_response)
    super

    add_section(ImpactHeader.new(
                  description:,
                  image: impact_image,
                  image_type: header_image.present? ? "header" : "logo",
                  title:,
                  variant: notable_death? ? "notable-death" : "plain",
                ))

    if navigation_items.any?
      add_section(Navigation.new(
                    items: navigation_items,
                  ))
    end

    add_section(ContentThenSidebarLayout.new(
                  content: Govspeak.new(govspeak: body),
                  sidebar: header_image && logo_image ? Image.new(image: logo_image) : nil,
                ))

    if details["about_page_link_text"].present?
      add_section(Link.new(link: "#{base_path}/about", link_text: details["about_page_link_text"]))
    end

    if featured_items.any?
      add_section(Featured.new(
                    items: featured_items,
                    ga4_image_card_json: {
                      event_name: "navigation",
                      type: "image_card",
                      section: "Featured",
                    },
                  ))
    end

    share_section = if details["social_media_links"].present?
                      Share.new(
                        heading_text: "Follow us",
                        links: format_social_media_links(details["social_media_links"]),
                      )
                    end
    add_section(ContentThenSidebarLayout.new(
                  content: DocumentList.new(
                    email_signup_link: "/email-signup?link=#{base_path}",
                    email_signup_link_text: "Get email updates",
                    heading_text: "Latest updates",
                    items: feed_items,
                    see_all_items_link: "/search/all?order=updated-newest&topical_events%5B%5D=#{base_path.split('/').last}",
                    see_all_items_link_text: "See more updates",
                  ),
                  sidebar: share_section,
                ))

    if organisations_ordered_by_emphasis.any?
      add_section(Involved.new(
                    heading: "Who's involved",
                    organisations: organisations_ordered_by_emphasis,
                  ))
    end
  end

  def feed_items
    @feed_items ||= FeedService.new(search_options: { filter_topical_events: base_path.split("/").last }).fetch_related_documents_with_format
  end

private

  def header_image
    return unless details["images"]

    details["images"].select { |i| i["type"] == "header" }.first&.deep_symbolize_keys
  end

  def logo_image
    return unless details["images"]

    details["images"].select { |i| i["type"] == "logo" }.first&.deep_symbolize_keys
  end

  def legacy_logo
    return unless details["image"]

    {
      sources: {
        desktop: details["image"]["high_resolution_url"],
        desktop_2x: nil,
        tablet: details["image"]["medium_resolution_url"],
        tablet_2x: nil,
        mobile: details["image"]["medium_resolution_url"],
        mobile_2x: nil,
      },
    }
  end

  def notable_death?
    linked("taxons").find { |taxon| taxon.base_path == "/society-and-culture/notable-death" }.present?
  end

  def impact_image
    [header_image, logo_image, legacy_logo].find { it }
  end

  def format_social_media_links(links)
    links.map do |social_media_link|
      {
        href: social_media_link["href"],
        text: social_media_link["title"],
        icon: social_media_link["service_type"],
      }
    end
  end

  def featured_items
    (details["ordered_featured_documents"] || []).map do |i|
      {
        href: i["href"],
        image_src: i["image"]["url"],
        image_alt: i["image"]["alt_text"],
        heading_text: i["title"],
        description: i["summary"],
      }
    end
  end

  def navigation_items
    (main_menu["items"] || []).map do |item|
      {
        text: item["text"],
        href: item["url"],
      }
    end
  end

  def main_menu
    @main_menu ||= YAML.load_file(Rails.root.join("config/navigation.yml")).fetch("main_menu", {})
  end
end
