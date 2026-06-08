class TopicalEventAboutPagePresenter
  attr_reader :flexible_sections

  def initialize(content_item)
    about = content_item.about

    @flexible_sections = []

    @flexible_sections << Breadcrumbs.new(breadcrumbs:)

    @flexible_sections << PageTitle.new(heading_text: about.title, lead_paragraph: about.description)

    @flexible_sections << SidebarThenContentLayout.new(
      sidebar: RichContentsList.new(contents_list: about.contents_list),
      content: Govspeak.new(govspeak: about.body),
    )
  end
