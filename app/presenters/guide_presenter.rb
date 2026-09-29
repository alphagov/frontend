class GuidePresenter < ContentItemPresenter
  def use_contextual_components?
    true
  end

  def page_title_options
    super.merge({
      heading_text: title,
      lead_paragraph: nil,
    })
  end

  def page_title
    "#{content_item.title}: #{content_item.current_part_title}"
  end

  def show_guide_navigation?
    content_item.parts.count > 1 && !hide_chapter_navigation?
  end

  def title
    return content_item.current_part_title if content_item.parts.any? && hide_chapter_navigation?

    content_item.title
  end

private

  def hide_chapter_navigation?
    content_item.part_of_step_navs? && content_item.hide_chapter_navigation?
  end
end
