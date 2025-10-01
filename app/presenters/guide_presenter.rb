class GuidePresenter < ContentItemPresenter
  def show_guide_navigation?
    content_item.parts.count > 1 && !hide_chapter_navigation?
  end

  def title
    return content_item.parts.first["title"] if replace_title_with_first_part_title?

    content_item.title
  end

private

  def hide_chapter_navigation?
    content_item.part_of_step_navs? && content_item.hide_chapter_navigation?
  end

  def replace_title_with_first_part_title?
    content_item.hide_chapter_navigation? && content_item.content_store_response["links"].key?("part_of_step_navs")
  end
end
