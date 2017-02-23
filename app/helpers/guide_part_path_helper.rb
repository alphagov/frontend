module GuidePartPathHelper
  def current_part_path(presented_content_item)
    guide_path(
      slug: presented_content_item.slug,
      part: presented_content_item.current_part.slug
    )
  end

  def previous_part_path(presented_content_item)
    guide_path(
      slug: presented_content_item.slug,
      part: presented_content_item.previous_part.slug
    )
  end

  def next_part_path(presented_content_item)
    guide_path(
      slug: presented_content_item.slug,
      part: presented_content_item.next_part.slug
    )
  end

  DEFAULT_COLUMN_HEIGHT = 3
  NUMBER_OF_COLUMNS = 2

  def parts_column_height(parts)
    column_height = (parts.length.to_f / NUMBER_OF_COLUMNS).ceil
    [column_height, DEFAULT_COLUMN_HEIGHT].max
  end
end
