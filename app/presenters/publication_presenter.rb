class PartPresenter
  attr_reader :part

  def initialize(part)
    @part = part
  end

  PASS_THROUGH_KEYS = [
    :slug, :title, :body, :name
  ]

  PASS_THROUGH_KEYS.each do |key|
    define_method key do
      part[key.to_s]
    end
  end
end

class PublicationPresenter
  attr_reader :artefact

  def initialize(artefact)
    @artefact = artefact
  end

  PASS_THROUGH_KEYS = [
    :title, :details
  ]

  PASS_THROUGH_DETAILS_KEYS = [
    :body, :introduction, :expectations, :video_url, :alternative_title,
    :overview, :name, :video_summary, :continuation_link, :licence_overview,
    :link, :will_continue_on, :more_information, :minutes_to_complete,
    :alternate_methods
  ]

  PASS_THROUGH_KEYS.each do |key|
    define_method key do
      artefact[key.to_s]
    end
  end

  PASS_THROUGH_DETAILS_KEYS.each do |key|
    define_method key do
      details[key.to_s]
    end
  end

  def type
    artefact["format"]
  end

  def parts
    @parts ||= build_parts
  end

  def build_parts
    if details
      parts = details["parts"]
      return unless parts
      parts.map{|part| PartPresenter.new(part)}
    end
  end

  def find_part(slug)
    parts.find{|part| part.slug == slug}
  end

  def slug
    web_url = artefact["web_url"]
    URI.parse(web_url).path.gsub("/", "")
  end

  def updated_at
    date = details["updated_at"]
    DateTime.parse(date) if date
  end

  # Parts stuff

  def part_index(slug)
    parts.index { |p| p.slug == slug }
  end

  def find_part(slug)
    return nil unless index = part_index(slug)
    parts[index]
  end

  def has_parts?(part)
    !! (has_previous_part?(part) || has_next_part?(part))
  end

  def has_previous_part?(part)
    index = part_index(part.slug)
    !! (index && index > 0)
  end

  def has_next_part?(part)
    index = part_index(part.slug)
    !! (index && (index + 1) < parts.length)
  end

  def part_after(part)
    part_at(part, 1)
  end

  def part_before(part)
    part_at(part, -1)
  end

private

  def part_at(part, relative_offset)
    return nil unless current_index = part_index(part.slug)
    other_index = current_index + relative_offset
    return nil unless (0 ... parts.length).include?(other_index)
    parts[other_index]
  end
end