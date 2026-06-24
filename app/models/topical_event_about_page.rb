class TopicalEventAboutPage < FlexiblePage
  def initialize(content_store_response)
    super

    add_section(Breadcrumbs.new(breadcrumbs:))
    add_section(PageTitle.new(heading_text: title, lead_paragraph: description))
    add_section(SidebarThenContentLayout.new(
                  sidebar: RichContentsList.new(contents_list:),
                  content: Govspeak.new(govspeak: body),
                ))
  end

  def breadcrumbs
    parent = linked("parent").first
    super << {
      title: parent.title,
      url: parent.base_path,
    }
  end

  def contents_outline
    list = (content_store_response.dig("details", "headers") || []).map { |header| header.except("headers").deep_symbolize_keys }
    ContentsOutline.new(list)
  end
end
