class HistoryPresenter < ContentItemPresenter
  def breadcrumbs
    default_breadcrumbs + [
      {
        title: "History of the UK Government",
        url: "/government/history",
      },
    ]
  end

  def contents
    ContentsOutlinePresenter.new(content_item.contents_outline).for_contents_list_component
  end

  def page_title_options
    {
      context: "History",
      heading_text: content_item.title,
      lead_paragraph: content_item.lead_paragraph,
    }
  end
end
