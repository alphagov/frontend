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
    :eligibility, :evaluation, :additional_information, :contact_details
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
      if parts
        parts.reject {|part|
          part['slug'] == "further-information" and (part['body'].nil? or part['body'].strip == "")
        }.map{|part| PartPresenter.new(part)}
      end
    end
  end

  def find_part(slug)
    parts.find{|part| part.slug == slug}
  end

  def slug
    URI.parse(web_url).path.gsub("/", "")
  end

  def updated_at
    date = @artefact["updated_at"]
    DateTime.parse(date) if date
  end

  def video_embed_url
    return nil unless video_url

    video = video_url.scan(/\?v=([A-Za-z0-9_\-]+)/)
    if video.any?
      "http://www.youtube.com/watch?v=#{video[0][0]}"
    else
      ""
    end
  end
end
