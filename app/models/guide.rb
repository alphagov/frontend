class Guide < ContentItem
  include Parts

  def hide_chapter_navigation?
    content_store_response["details"]["hide_chapter_navigation"].presence || false
  end

  def is_child_benefit?
    base_path == "/child-benefit"
  end

  def part_of_step_navs?
    content_store_response["links"].key?("part_of_step_navs")
  end
end
