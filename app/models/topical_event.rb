class TopicalEvent < FlexiblePage
  include EmphasisedOrganisations

private

  def default_flexible_sections
    sections = []
    sections << impact_header_section
    sections << body_section if body.present?
    sections << about_link_section if details["about_page_link_text"].present?
    sections << featured_section if details["ordered_featured_documents"].any?
    sections << feed_and_social_section
    sections << whos_involved_section if organisations_ordered_by_emphasis.any?
    sections
  end

  def impact_header_section
    {
      type: "impact_header",
      title:,
      description:,
      breadcrumbs:,
      image: impact_image,
    }
  end

  def body_section
    {
      type: "rich_content",
      govspeak: body,
    }
  end

  def about_link_section
    {
      type: "link",
      link: "#{base_path}/about",
      link_text: details["about_page_link_text"],
    }
  end

  def featured_section
    {
      type: "featured",
      ordered_featured_documents: details["ordered_featured_documents"],
    }
  end

  def feed_and_social_section
    {
      type: "feed",
      feed_heading_text: "Latest updates",
      email_signup_link: "/email-signup?link=#{base_path}",
      email_signup_link_text: "Get emails about this page",
      items: FeedService.new(search_options: { filter_topical_events: base_path.split("/").last }).fetch_related_documents_with_format,
      see_all_items_link: "/search/all?order=updated-newest&topical_events[]=#{base_path.split('/').last}",
      see_all_items_link_text: "See more updates",
      share_links_heading_text: "Follow us",
      share_links: format_social_media_links(details["social_media_links"] || []),
    }
  end

  def whos_involved_section
    {
      type: "involved",
      organisations: organisations_ordered_by_emphasis.map(&:content_store_response),
    }
  end

  def impact_image
    return unless details["image"]

    {
      sources: {
        desktop: details["image"]["high_resolution_url"],
        desktop_2x: details["image"]["high_resolution_url"],
        tablet: details["image"]["medium_resolution_url"],
        tablet_2x: details["image"]["medium_resolution_url"],
        mobile: details["image"]["url"],
        mobile_2x: details["image"]["url"],
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
end
