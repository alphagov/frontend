class TopicalEventAboutPagePresenter < ContentItemPresenter
  def page_title_options
    {
      heading_text: content_item.about.title,
      lead_paragraph: content_item.about.summary,
    }
  end

  def contents_list
    ContentsOutlinePresenter.new(content_item.about.contents_outline).for_contents_list_component
  end

  def content
    content_item.about.body
  end

  def breadcrumb_options
    {
      collapse_on_mobile: true,
      breadcrumbs:,
      margin_bottom: 5,
    }
  end

private

  def breadcrumbs
    [
      {
        title: "Home",
        url: "/",
      },
      {
        title: content_item.title,
        url: content_item.base_path,
      },
    ]
  end
end
