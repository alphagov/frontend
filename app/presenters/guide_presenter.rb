class GuidePresenter < ContentItemPresenter
  def title
    return content_item.parts.first["title"] if replace_title_with_first_part_title?

    content_item.title
  end

private

  def replace_title_with_first_part_title?
    content_item.hide_chapter_navigation? && content_item.content_store_response["links"].key?("part_of_step_navs")
  end
end