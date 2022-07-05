module ContentItem
  module RecruitmentBanner
    SURVEY_URL_ONE = "https://GDSUserResearch.optimalworkshop.com/treejack/3z828uy6".freeze
    SURVEY_URLS = {
      "/bank-holidays" => SURVEY_URL_ONE,
      "/sold-bought-vehicle" => SURVEY_URL_ONE,
      "/vehicle-tax" => SURVEY_URL_ONE,
    }.freeze

    def recruitment_survey_url
      SURVEY_URLS[base_path]
    end

  private

    def base_path
      content_item["base_path"]
    end
  end
end
