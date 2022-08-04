module ContentItem
  module RecruitmentBanner
    SURVEY_URL_ONE = "https://GDSUserResearch.optimalworkshop.com/treejack/b3cu012d".freeze
    SURVEY_URLS = {
      "/bank-holidays" => SURVEY_URL_ONE,
      "/sold-bought-vehicle" => SURVEY_URL_ONE,
      "/vehicle-tax" => SURVEY_URL_ONE,
      "/browse/working" => SURVEY_URL_ONE,
    }.freeze

    def recruitment_survey_url
      path = ur_recruiting_browse_page_content_is_tagged_to || content_item_base_path
      SURVEY_URLS[path]
    end

  private

    def content_item_base_path
      content_item["base_path"]
    end

    def ur_recruiting_browse_page_content_is_tagged_to
      browse_pages = SURVEY_URLS.keys.select { |path| path.starts_with? "/browse/" }
      browse_pages.find { |browse_base_path| content_tagged_to(browse_base_path).present? }
    end

    def mainstream_browse_pages_content_is_tagged_to
      content_item["links"]["mainstream_browse_pages"] if content_item["links"]
    end

    def content_tagged_to(browse_base_path)
      return [] unless mainstream_browse_pages_content_is_tagged_to

      mainstream_browse_pages_content_is_tagged_to.find do |mainstream_browse_page|
        mainstream_browse_page["base_path"].starts_with? browse_base_path
      end
    end
  end
end
