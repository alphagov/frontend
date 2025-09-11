module ContentsList
  def headers_for_contents_list_component(additional_headers: [], nested_headers: false, visible: true)
    return [] if visible == false

    outline_headers = nested_headers ? content_item.headers : only_level_two_headers

    contents_outline = ContentsOutline.new(outline_headers + additional_headers)

    return [] unless contents_outline.level_two_headers?

    ContentsOutlinePresenter.new(contents_outline).for_contents_list_component
  end

private

  def only_level_two_headers
    content_item.headers.map { |header| header.except("headers") }
  end
end
