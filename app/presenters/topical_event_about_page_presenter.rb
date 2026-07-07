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
    default_breadcrumb_options.tap do |opts|
      opts[:breadcrumbs] << {
        title: content_item.title,
        url: content_item.base_path,
      }
    end
  end
end
