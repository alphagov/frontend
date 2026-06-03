class TopicalEventAboutPage < FlexiblePage
  def initialize(content_store_response)
    super

    if navigation_items.any?
      add_section(Navigation.new(items: navigation_items))
    end

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

private

  def contents_list
    (content_store_response.dig("details", "headers") || []).map { |header| header.except("headers").deep_symbolize_keys }
  end

  def navigation_items
    (main_menu["items"] || []).map do |item|
      {
        text: item["text"],
        links: (item["links"] || []).map do |link|
          {
            text: link["text"],
            url: link["url"],
          }
        end,
      }
    end
  end

  def main_menu
    @main_menu ||= YAML.load_file(Rails.root.join("config/navigation.yml")).fetch("main_menu", {})
  end
end
