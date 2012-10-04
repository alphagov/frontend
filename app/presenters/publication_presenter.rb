class PublicationPresenter
  include GdsApi::PartMethods

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
end