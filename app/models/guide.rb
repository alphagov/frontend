class Guide < ContentItem
  include Parts

  def hide_chapter_navigation?
    content_store_response["details"]["hide_chapter_navigation"].presence || false
  end

  def is_evisa?
    base_path == "/evisa"
  end
end
