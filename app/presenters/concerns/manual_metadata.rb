module ManualMetadata
  include LinkHelper
  include DateHelper

  def other_metadata(is_updates_page: false)
    manual = content_item.manual_content_item

    update_at_text = display_date(manual.public_updated_at).to_s

    unless is_updates_page
      update_at_text += " - #{govuk_styled_link(I18n.t('formats.manuals.see_all_updates'), path: "#{manual.base_path}/updates")}"
    end

    { I18n.t("formats.manuals.updated") => update_at_text }
  end
end
