module ContentItem
  module RecruitmentBanner
    COST_OF_LIVING_SURVEY_URL = "https://GDSUserResearch.optimalworkshop.com/treejack/cbd7a696cbf57c683cbb2e95b4a36c8a".freeze
    SURVEY_URL_MAPPINGS = {
      "/sign-in-universal-credit" => COST_OF_LIVING_SURVEY_URL,
      "/check-state-pension" => COST_OF_LIVING_SURVEY_URL,
      "/council-tax-bands" => COST_OF_LIVING_SURVEY_URL,
    }.freeze

    def recruitment_survey_url
      cost_of_living_test_url
    end

    def cost_of_living_test_url
      key = content_item["base_path"]
      SURVEY_URL_MAPPINGS[key]
    end
  end
end
