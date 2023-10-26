module ContentItem
  module RecruitmentBanner
    BENEFITS_SURVEY_URL = "https://signup.take-part-in-research.service.gov.uk/home?utm_campaign=Content_History&utm_source=Hold_gov_to_account&utm_medium=gov.uk&t=GDS&id=16".freeze
    BENEFITS_SURVEY_URL_MAPPINGS = {
      "/sign-in-universal-credit" => BENEFITS_SURVEY_URL,
      "/check-state-pension" => BENEFITS_SURVEY_URL,
    }.freeze

    def benefits_recruitment_survey_url
      key = content_item["base_path"]
      BENEFITS_SURVEY_URL_MAPPINGS[key]
    end
  end
end
