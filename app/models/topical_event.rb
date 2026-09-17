class TopicalEvent < FlexiblePage
  include EmphasisedOrganisations

  def initialize(content_store_response)
    super

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
end
