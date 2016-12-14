class PublicationPresenter
  attr_reader :artefact

  attr_accessor :places, :parts, :current_part

  def initialize(artefact, places = nil)
    @artefact = artefact
    @places = places if places
  end

  PASS_THROUGH_KEYS = [
    :title, :details, :web_url, :in_beta
  ]

  PASS_THROUGH_DETAILS_KEYS = [
    :body, :short_description, :introduction, :need_to_know, :video_url,
    :summary, :overview, :name, :video_summary, :continuation_link, :licence_overview,
    :link, :will_continue_on, :more_information, :downtime,
    :alternate_methods, :place_type, :min_value, :max_value, :organiser, :max_employees,
    :eligibility, :evaluation, :additional_information, :contact_details, :language, :country,
    :alert_status, :change_description, :caption_file, :nodes, :large_image, :medium_image, :small_image,
    :department_analytics_profile, :description
  ]

  PASS_THROUGH_KEYS.each do |key|
    define_method key do
      artefact[key.to_s]
    end
  end

  PASS_THROUGH_DETAILS_KEYS.each do |key|
    define_method key do
      details[key.to_s] if details
    end
  end

  def start_button_text
    details["start_button_text"] || "Start now"
  end

  def format
    @artefact["format"]
  end

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
        parts.reject { |part|
          part['slug'] == "further-information" && (part['body'].nil? || part['body'].strip == "")
        }.map { |part| PartPresenter.new(part) }
      end
    end
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

  def slug
    URI.parse(web_url).path.sub(%r{\A/}, "")
  end

  def places
    if @places
      @places.map do |place|
        place['text']    = place['url'].truncate(36) if place['url']
        place['address'] = [place['address1'], place['address2']].compact.map(&:strip).join(", ")
        place
      end
    end
  end

  def updated_at
    date = @artefact["updated_at"]
    DateTime.parse(date) if date
  end

  def video_embed_url
    return nil unless video_url

    video = video_url.scan(/\?v=([A-Za-z0-9_\-]+)/)
    if video.any?
      "https://www.youtube.com/watch?v=#{video[0][0]}"
    else
      ""
    end
  end

  def promotion_choice
    choice = promotion_choice_details['choice']
    choice.empty? ? "none" : choice
  end

  def promotion_url
    promotion_choice_details['url']
  end

  def to_json
    {
      places: places
    }.to_json
  end


private

  def part_at(part, relative_offset)
    current_index = part_index(part.slug)
    return nil unless current_index
    other_index = current_index + relative_offset
    return nil unless (0...parts.length).cover?(other_index)
    parts[other_index]
  end

  def promotion_choice_details
    presentation_toggles.fetch('promotion_choice', 'choice' => '', 'url' => '')
  end

  def presentation_toggles
    details.fetch('presentation_toggles', {})
  end
end
