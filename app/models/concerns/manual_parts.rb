module ManualParts
  extend ActiveSupport::Concern

  included do
    def title
      linked("manual").first.title
    end

    def page_title
      "#{breadcrumb} - #{manual_page_title}"
    end
  end

private

  def breadcrumb
    content_store_response["details"]["section_id"] || title
  end

  def manual_page_title
    title = content_store_response["title"] || ""
    title += " - " if title.present?

    if hmrc?
      I18n.t("formats.manuals.hmrc_title", title:)
    else
      I18n.t("formats.manuals.title", title:)
    end
  end

  def hmrc?
    %w[hmrc_manual hmrc_manual_section].include?(schema_name)
  end
end
