module AssistedDigitalSatisfactionSurvey
  SLUGS_IN_SURVEY = [
    "done/register-flood-risk-exemption",
    "done/waste-carrier-or-broker-registration",
    "done/register-waste-exemption",
  ].freeze

  def self.show_survey?(slug)
    SLUGS_IN_SURVEY.include? slug
  end
end
