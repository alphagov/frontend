module AssistedDigitalSatisfactionSurvey
  SLUGS_IN_HELP_WITH_FEES_SURVEY = [
    'done/register-flood-risk-exemption'
  ].freeze

  def self.show_help_with_fees_survey?(slug)
    SLUGS_IN_HELP_WITH_FEES_SURVEY.include? slug
  end
end
