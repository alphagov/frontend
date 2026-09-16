class TopicalEventAboutPagePresenter < ContentItemPresenter
  def contents_list
    ContentsOutlinePresenter.new(content_item.contents_outline).for_contents_list_component
  end

  def content
    content_item.body
  end

  def breadcrumbs
    default_breadcrumbs + [
      {
        title: content_item.parent.title,
        url: content_item.parent.base_path,
      },
    ]
  end
end
