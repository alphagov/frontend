class FlexiblePage < ContentItem
  attr_reader :flexible_sections

  def initialize(content_store_response)
    super

    flexible_section_array = content_store_response.dig("details", "flexible_sections") || default_flexible_sections
    @flexible_sections = flexible_section_array.map { |hash| FlexiblePage::FlexibleSectionFactory.build(hash.deep_stringify_keys, self) }
  end

  def breadcrumbs
    [
      {
        title: "Home",
        url: "/",
      },
    ]
  end

  def feed_items
    feed_sections = flexible_sections.select { |section| section.type == "feed" }

    feed_sections.any? ? feed_sections.first.items : []
  end

private

  def default_flexible_sections
    []
  end
end
