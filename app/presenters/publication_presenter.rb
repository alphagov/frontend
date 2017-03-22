class PublicationPresenter
  attr_reader :artefact

  def initialize(artefact)
    @artefact = artefact
  end

  PASS_THROUGH_KEYS = [
    :details, :in_beta, :title, :web_url
  ]

  PASS_THROUGH_DETAILS_KEYS = [
    :additional_information, :alert_status, :alternate_methods, :body,
    :caption_file, :change_description, :contact_details, :country,
    :continuation_link, :department_analytics_profile, :description, :downtime,
    :eligibility, :evaluation, :introduction, :language, :large_image,
    :link, :max_employees, :max_value, :medium_image, :min_value,
    :more_information, :name, :need_to_know, :nodes, :organiser, :overview,
    :place_type, :short_description, :small_image, :summary, :will_continue_on
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

  def locale
    language
  end
end
