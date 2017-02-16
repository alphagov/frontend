class GuidePresenter < ContentItemPresenter
  attr_accessor :parts, :current_part

  def current_part=(part_slug)
    return unless parts && parts.any?

    part = part_slug || parts.first.slug
    @current_part = find_part(part)
  end

  def current_part_number
    parts.index(current_part) + 1
  end

  def parts
    @parts ||= build_parts
  end

  def build_parts
    if details
      parts = details["parts"]
      if parts
        parts.reject { |part| invalid_part?(part) }.map { |part| PartPresenter.new(part) }
      end
    end
  end

  def invalid_part?(part)
    part['slug'] == "further-information" && (part['body'].nil? || part['body'].strip == "")
  end

  def find_part(slug)
    parts && parts.find { |part| part.slug == slug }
  end

  def empty_part_list?
    parts && parts.empty?
  end

  def has_parts?
    parts && parts.any?
  end

  def part_before(part)
    part_at(part, -1)
  end

  def part_after(part)
    part_at(part, 1)
  end

  def part_index(slug)
    parts.index { |p| p.slug == slug }
  end

  def has_previous_part?
    index = part_index(current_part.slug)
    !! (index && index > 0)
  end

  def previous_part
    part_at(current_part, -1)
  end

  def has_next_part?
    index = part_index(current_part.slug)
    !! (index && (index + 1) < parts.length)
  end

  def next_part
    part_at(current_part, 1)
  end

private

  def part_at(part, relative_offset)
    current_index = part_index(part.slug)
    return nil unless current_index
    other_index = current_index + relative_offset
    return nil unless (0...parts.length).cover?(other_index)
    parts[other_index]
  end
end
