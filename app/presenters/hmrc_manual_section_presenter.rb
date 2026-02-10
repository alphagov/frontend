class HmrcManualSectionPresenter < ContentItemPresenter
  include ManualMetadata

  def breadcrumbs
    base_breadcrumb = {
      title: I18n.t("formats.manuals.breadcrumb_contents"),
      url: content_item.manual_base_path,
    }

    additional_breadcrumbs = content_item.details["breadcrumbs"].map do |breadcrumb|
      {
        title: breadcrumb["section_id"],
        url: breadcrumb["base_path"],
      }
    end

    [base_breadcrumb] + additional_breadcrumbs
  end

  def document_heading
    [content_item.details["section_id"], content_item.title].compact.join(" - ")
  end
end
