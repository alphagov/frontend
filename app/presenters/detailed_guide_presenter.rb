class DetailedGuidePresenter < ContentItemPresenter
  def headers_for_content_list_component
    return [] unless content_item.headers

    ContentsOutlinePresenter.new(contents_list_headings).for_contents_list_component
  end

  def contents_list_headings; end
end
