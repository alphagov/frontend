module ManualSections
  extend ActiveSupport::Concern

  MOJ_ORGANISATION_CONTENT_ID = "dcc907d6-433c-42df-9ffb-d9c68be5dc4d".freeze
  included do
    def manual_title
      linked("manual").first.title
    end

    def document_heading
      document_heading = []

      document_heading << content_store_response["details"]["section_id"] if content_store_response["details"]["section_id"]
      document_heading << content_store_response["title"] if content_store_response["title"]
    end

    def breadcrumbs
      [
        {
          title: I18n.t(show_contents_list? ? "formats.manuals.contents_list_breadcrumb_contents" : "formats.manuals.breadcrumb_contents"),
          url: base_path,
        },
      ]
    end

    def hmrc?
      %w[hmrc_manual hmrc_manual_section].include?(schema_name)
    end
  end

private

  def breadcrumb
    content_store_response["details"]["section_id"] || manual_title
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

  def show_contents_list?
    organisation_content_id == MOJ_ORGANISATION_CONTENT_ID
  end

  def organisation_content_id
    content_store_response.dig("links", "organisations", 0, "content_id")
  end
end
