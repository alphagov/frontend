class TopicalEventAboutPagePresenter
  include FlexiblePage::FlexibleSection

  attr_reader :flexible_sections

  def initialize(content_item)
    @content_item = content_item
    about = content_item.about

    add_section(Breadcrumbs.new(breadcrumbs:))
    add_section(PageTitle.new(heading_text: about.title, lead_paragraph: about.description))
    add_section(SidebarThenContentLayout.new(
                  sidebar: RichContentsList.new(contents_list: about.contents_list),
                  content: Govspeak.new(govspeak: about.body),
                ))
  end

private

  def breadcrumbs
    [
      {
        title: "Home",
        url: "/",
      },
      {
        title: @content_item.title,
        url: @content_item.base_path,
      },
    ]
  end

  def add_section(flexible_section)
    @flexible_sections ||= []
    @flexible_sections << flexible_section
  end
end
