class TopicalEvent < FlexiblePage
  include EmphasisedOrganisations

  About = Data.define(:title, :description, :contents_list, :body)

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

  def about
    About.new(
      title:,
      description:,
      body: details["about"]["body"],
      contents_list: [],
    )
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
end
