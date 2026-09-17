class TopicalEvent < FlexiblePage
  include EmphasisedOrganisations

  def initialize(content_store_response)
    super

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
