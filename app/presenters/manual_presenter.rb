class ManualPresenter < ContentItemPresenter
  include LinkHelper
  include DateHelper

  def other_metadata
    updated_metadata(content_item.public_updated_at)
  end

private

  def updated_metadata(updated_at)
    current_path = content_item.base_path

    if (content_item.hmrc? || content_item.manual?) && current_path == "#{content_item.base_path}/updates"
      update_at_text = display_date(updated_at).to_s
    else
      updates_link = govuk_styled_link(I18n.t("formats.manuals.see_all_updates"), path: "#{content_item.base_path}/updates")
      update_at_text = "#{display_date(updated_at)} - #{updates_link}"
    end

    { I18n.t("formats.manuals.updated") => update_at_text }
  end
end
