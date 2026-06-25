class HistoryPresenter < ContentItemPresenter
  def page_title_options
    {
      context: "History",
      heading_text: content_item.title,
      lead_paragraph: content_item.lead_paragraph,
    }
  end

  def contents_list
    ContentsOutlinePresenter.new(content_item.contents_outline).for_contents_list_component
  end

  def breadcrumb_options
    default_breadcrumb_options.tap do |opts|
      opts[:breadcrumbs] << {
        title: "History of the UK Government",
        url: "/government/history",
      }
    end
  end

  def image
    nil
  end
end
