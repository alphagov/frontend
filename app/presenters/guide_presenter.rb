class GuidePresenter < ContentItemPresenter
  attr_reader :current_part

  def current_part=(part_slug = nil)
    @current_part =
      if part_slug
        find_part(part_slug)
      else
        parts.first
      end
  end

  def part_not_found?
    current_part.nil?
  end

  def current_part_number
    current_part_index + 1
  end

  def part_number(part)
    part_index(part) + 1
  end

  def parts
    @_parts ||= build_parts
  end

  def empty_part_list?
    parts.empty?
  end

  def has_parts?
    parts.any?
  end

  def has_previous_part?
    current_part_index && current_part_index > 0
  end

  def previous_part
    part_at(current_part, -1)
  end

  def has_next_part?
    current_part_number && current_part_number < parts.length
  end

  def next_part
    part_at(current_part, 1)
  end

private

  def current_part_index
    part_index(current_part)
  end

  def part_index(part)
    parts.index { |p| p == part }
  end

  def find_part(slug)
    parts.find { |part| part.slug == slug }
  end

  def build_parts
    if details
      parts = details["parts"] || []
      parts
        .reject { |part| invalid_part?(part) }
        .map { |part| PartPresenter.new(part) }
    else
      []
    end
  end

  def invalid_part?(part)
    part['slug'] == "further-information" && (part['body'].nil? || part['body'].strip == "")
  end

  def part_at(part, relative_offset)
    return nil unless part
    current_index = part_index(part)
    return nil unless current_index
    other_index = current_index + relative_offset
    return nil unless (0...parts.length).cover?(other_index)
    parts[other_index]
  end
end
