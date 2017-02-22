# I can be safely deleted when the Programme format is retired
module ProgrammePartHelper
  def programme_part_path(slug, part = nil, edition = nil)
    path = "/#{slug}"
    path += "/#{part}" if part
    path += "?edition=#{edition}" if edition
    path
  end

  def programme_previous_part_path(publication, part, edition)
    raise "No previous part" if publication.part_before(part).nil?
    programme_part_path(publication.slug, publication.part_before(part).slug, edition)
  end

  def programme_next_part_path(publication, part, edition)
    raise "No next part" if publication.part_after(part).nil?
    programme_part_path(publication.slug, publication.part_after(part).slug, edition)
  end

  def programme_part_number(parts, part)
    parts.index(part) + 1
  rescue => e
    Rails.logger.info "#{e.message} : #{parts.inspect} : #{part.inspect}"
    "-"
  end

  DEFAULT_COLUMN_HEIGHT = 3
  NUMBER_OF_COLUMNS = 2

  def programme_parts_column_height(parts)
    column_height = (parts.length.to_f / NUMBER_OF_COLUMNS).ceil
    [column_height, DEFAULT_COLUMN_HEIGHT].max
  end
end
