class FlexiblePage < ContentItem
  attr_reader :flexible_sections

  def initialize(content_store_response)
    super

    @flexible_sections = (content_store_response.dig("details", "flexible_sections") || []).map { |hash| FlexiblePage::FlexibleSectionFactory.build(hash, self) }
  end
end
