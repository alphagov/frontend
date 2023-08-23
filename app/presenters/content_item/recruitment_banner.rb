module ContentItem
  module RecruitmentBanner
    SURVEY_URL = "https://surveys.publishing.service.gov.uk/s/4J4QD4/".freeze
    SURVEY_URL_MAPPINGS = {
      "/check-national-insurance-record" => SURVEY_URL,
      "/check-state-pension" => SURVEY_URL,
      "/student-finance-register-login" => SURVEY_URL,
      "/sign-in-universal-credit" => SURVEY_URL,
    }.freeze

    def recruitment_survey_url
      user_research_test_url
    end

    def user_research_test_url
      key = content_item["base_path"]
      SURVEY_URL_MAPPINGS[key]
    end
  end
end
