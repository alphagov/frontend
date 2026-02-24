class GuidePresenter < ContentItemPresenter
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

  def ga4_scroll_tracking?
    [
      "/apply-to-come-to-the-uk",
      "/apply-to-come-to-the-uk/prepare-your-application",
      "/apply-to-come-to-the-uk/prove-your-identity",
      "/apply-to-come-to-the-uk/getting-a-decision-on-your-application",
    ].include? content_item.base_path
  end

private

  def hide_chapter_navigation?
    content_item.part_of_step_navs? && content_item.hide_chapter_navigation?
  end
end
