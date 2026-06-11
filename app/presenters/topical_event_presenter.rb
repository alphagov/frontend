class TopicalEventPresenter
  include FlexiblePage::FlexibleSection

  attr_reader :flexible_sections

  def impact_header_options
    {
      heading: @content_item.title,
      description: @content_item.description,
      image: @content_item.impact_image,
      image_type: @content_item.header_image.present? ? "header" : "logo",
      variant: @content_item.notable_death? ? "notable-death" : "plain",
    }
  end

  def initialize(content_item)
    @content_item = content_item
    # add_section(ImpactHeader.new(
    #               description: content_item.description,
    #               image: content_item.impact_image,
    #               image_type: content_item.header_image.present? ? "header" : "logo",
    #               title: content_item.title,
    #               variant: content_item.notable_death? ? "notable-death" : "plain",
    #             ))

    secondary_image = content_item.header_image && content_item.logo_image ? Image.new(image: content_item.logo_image) : nil
    add_section(ContentThenSidebarLayout.new(
                  content: Govspeak.new(govspeak: content_item.body),
                  sidebar: secondary_image,
                ))

    if content_item.details["about_page_link_text"].present?
      add_section(Link.new(link: "#{content_item.base_path}/about", link_text: content_item.details["about_page_link_text"]))
    end

    if content_item.featured_items.any?
      add_section(Featured.new(
                    items: content_item.featured_items,
                    ga4_image_card_json: {
                      event_name: "navigation",
                      type: "image_card",
                      section: "Featured",
                    },
                  ))
    end

    share_section = if content_item.details["social_media_links"].present?
                      Share.new(
                        heading_text: "Follow us",
                        links: content_item.format_social_media_links(content_item.details["social_media_links"]),
                      )
                    end

    add_section(ContentThenSidebarLayout.new(
                  content: DocumentList.new(
                    email_signup_link: "/email-signup?link=#{content_item.base_path}",
                    email_signup_link_text: "Get email updates",
                    heading_text: "Latest updates",
                    items: content_item.feed_items,
                    see_all_items_link: "/search/all?order=updated-newest&topical_events%5B%5D=#{content_item.base_path.split('/').last}",
                    see_all_items_link_text: "See more updates",
                  ),
                  sidebar: share_section,
                ))

    if content_item.organisations_ordered_by_emphasis.any?
      add_section(Involved.new(
                    heading: "Who's involved",
                    organisations: content_item.organisations_ordered_by_emphasis,
                  ))
    end
  end

private

  def add_section(flexible_section)
    @flexible_sections ||= []
    @flexible_sections << flexible_section
  end
end
