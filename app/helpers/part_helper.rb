
# View helper for all things related to parts as provided by
# the Parted module.
module PartHelper
  def part_path(slug, part = nil, edition = nil)
    opts = Hash[{ slug: slug, part: part, edition: edition }.select { |k, v| v }]
    publication_path(opts)
  end

  def previous_part_path(publication, part, edition)
    raise "No previous part" if publication.part_before(part).nil?
    part_path(publication.slug, publication.part_before(part).slug, edition)
  end

  def next_part_path(publication, part, edition)
    raise "No next part" if publication.part_after(part).nil?
    part_path(publication.slug, publication.part_after(part).slug, edition)
  end

  def part_number(parts, part)
    parts.index(part) + 1
  rescue => e
    Rails.logger.info "#{e.message} : #{parts.inspect} : #{part.inspect}"
    "-"
  end

  DEFAULT_COLUMN_HEIGHT = 3
  NUMBER_OF_COLUMNS = 2

  def parts_column_height(parts)
    column_height = (parts.length.to_f / NUMBER_OF_COLUMNS).ceil
    [column_height, DEFAULT_COLUMN_HEIGHT].max
  end
end
