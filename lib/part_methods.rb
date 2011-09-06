module PartMethods
  def part_index(slug)
    parts.index { |p| p.slug == slug }
  end

  def find_part(slug)
    return nil unless index = part_index(slug)
    parts[index]
  end

  def part_after(part)
    return nil unless index = part_index(part.slug)
    next_index = index + 1
    return nil if next_index >= parts.length
    parts[next_index]
  end

  def has_previous_part?(part)
    index = part_index(part.slug)
    !index.nil? && index > 0 && true
  end

  def has_next_part?(part)
    index = part_index(part.slug)
    !index.nil? && (index + 1) < parts.length && true
  end

  def part_before(part)
    return nil unless index = part_index(part.slug)
    previous_index = index - 1
    return nil if previous_index < 0
    parts[previous_index]
  end
end
