class PublicationPresenter
  include GdsApi::PartMethods

  attr_reader :artefact

  attr_accessor :places

  def initialize(artefact)
    @artefact = artefact
  end

  PASS_THROUGH_KEYS = [
    :title, :details, :web_url
  ]

  PASS_THROUGH_DETAILS_KEYS = [
    :body, :short_description, :introduction, :expectations, :video_url, :alternative_title,
    :overview, :name, :video_summary, :continuation_link, :licence_overview,
    :link, :will_continue_on, :more_information, :minutes_to_complete,
    :alternate_methods, :place_type, :min_value, :max_value, :organiser, :max_employees,
    :eligibility, :evaluation, :additional_information, :contact_details, :language, :country
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

  def type
    artefact["format"]
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

  def slug
    URI.parse(web_url).path.sub("/", "")
  end

  def places
    if details && details["places"]
      details["places"].map do |place| 
        place['text']    = place['url'].truncate(36) if place['url']
        place['address'] = [place['address1'], place['address2']].compact.map(&:strip).join(", ")
        place
      end
    else
      []
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

  def to_json
    {
      places: places
    }.to_json
  end
end
