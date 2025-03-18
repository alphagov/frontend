class LandingPage < ContentItem
  attr_reader :blocks, :navigation_groups, :breadcrumbs, :theme

  ADDITIONAL_CONTENT_PATH = "lib/data/landing_page_content_items".freeze

  def initialize(content_store_response)
    super

    @breadcrumbs = content_store_response.dig("details", "breadcrumbs")&.map { { title: _1["title"], url: _1["href"] } }
    @navigation_groups = (content_store_response.dig("details", "navigation_groups") || []).index_by { _1["id"] }
    @blocks = (content_store_response.dig("details", "blocks") || []).map { |block_hash| BlockFactory.build(block_hash, self) }
    @theme = safe_theme(content_store_response.dig("details", "theme"))
  end

private

  def safe_theme(value)
    return value if value == "prime-ministers-office-10-downing-street"

    "default"
  end
end
