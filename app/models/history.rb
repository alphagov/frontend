class History < FlexiblePage
  include HasImages

  def initialize(content_store_response)
    super

    add_section(Breadcrumbs.new(breadcrumbs: []))
    add_section(PageTitle.new(context: "History", heading_text: title, lead_paragraph:))
    add_section(SidebarThenContentLayout.new(
                  sidebar: RichContentsList.new(contents_list:, image:),
                  content: Govspeak.new(govspeak: body),
                ))
  end

  def lead_paragraph
    content_store_response.dig("details", "lead_paragraph")
  end

private

  def contents_list
    (content_store_response.dig("details", "headers") || []).map { |header| header.except("headers").deep_symbolize_keys }
  end
end
