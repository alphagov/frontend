module ContentsList
  def headers_for_contents_list_component
    return [] unless contents_outline.level_two_headers?

    ContentsOutlinePresenter.new(contents_outline).for_contents_list_component
  end

private

  def contents_outline
    @contents_outline ||= ContentsOutline.new(valid_outline_headers)
  end

  def valid_outline_headers
    content_item.headers.map { |header| header.except("headers") }
  end
end
