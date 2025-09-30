module ManualParts
  extend ActiveSupport::Concern

  included do
    def title
      content_store_response["links"]["manual"].first["title"]
    end

     def page_title
      title = content_item["title"] || ""
      title += " - " if title.present?

      if hmrc?
        I18n.t("manuals.hmrc_title", title:)
      else
        I18n.t("manuals.title", title:)
      end
    end
    alias_method :manual_page_title, :page_title
  end
end
