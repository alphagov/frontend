class FlexiblePage < ContentItem
  include FlexiblePage::FlexibleSection

  attr_reader :flexible_sections

  def initialize(content_store_response)
    super

    @flexible_sections = []
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

  def add_section(flexible_section)
    flexible_sections << flexible_section
  end
end
