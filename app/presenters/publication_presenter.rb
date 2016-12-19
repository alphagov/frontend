class PublicationPresenter
  attr_reader :artefact

  def initialize(artefact)
    @artefact = artefact
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

  def slug
    URI.parse(web_url).path.sub(%r{\A/}, "")
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

  def promotion_choice_details
    presentation_toggles.fetch('promotion_choice', 'choice' => '', 'url' => '')
  end

  def presentation_toggles
    details.fetch('presentation_toggles', {})
  end
end
