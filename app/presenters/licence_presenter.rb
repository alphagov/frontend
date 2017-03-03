class LicencePresenter
  attr_reader :artefact

  def initialize(artefact)
    @artefact = artefact
  end

  PASS_THROUGH_KEYS = [
    :details, :in_beta, :title, :web_url
  ].freeze

  PASS_THROUGH_DETAILS_KEYS = [
    :continuation_link, :department_analytics_profile, :description, :downtime,
    :language, :licence_identifier, :licence_overview,
    :licence_short_description, :short_description, :will_continue_on
  ].freeze

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

  def format
    @artefact["format"]
  end

  def slug
    URI.parse(web_url).path.sub(%r{\A/}, "")
  end

  def updated_at
    date = @artefact["updated_at"]
    DateTime.parse(date).in_time_zone if date
  end

  def locale
    language
  end
end
