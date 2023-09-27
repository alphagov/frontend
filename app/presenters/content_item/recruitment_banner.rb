module ContentItem
  module RecruitmentBanner
    SURVEY_URL = "https://surveys.publishing.service.gov.uk/s/SNFVW1/".freeze
    SURVEY_URL_MAPPINGS = {
      "/get-information-about-a-company" => SURVEY_URL,
      "/check-if-you-need-tax-return" => SURVEY_URL,
      "/view-right-to-work" => SURVEY_URL,
      "/trade-tariff" => SURVEY_URL,
      "/register-for-self-assessment" => SURVEY_URL,
      "/file-your-confirmation-statement-with-companies-house" => SURVEY_URL,
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
