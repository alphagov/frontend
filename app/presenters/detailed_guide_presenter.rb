class DetailedGuidePresenter < ContentItemPresenter
  def headers_for_contents_list_component
    @headers = contents_list_headings
    return [] unless show_contents_list?

    ContentsOutlinePresenter.new(@headers).for_contents_list_component
  end

  def logo
    return unless content_item.image

    { path: content_item.image["url"], alt_text: "European structural investment funds" }
  end

private

  def show_contents_list?
    @headers.present? && @headers.level_two_headers?
  end

  def contents_list_headings
    exclude_nested_headings

    ContentsOutline.new(content_item.headers) if content_item.headers.present?
  end

  def exclude_nested_headings
    content_item.headers.each do |header|
      header.delete("headers") unless header["headers"].nil?
    end
  end
end
