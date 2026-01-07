class ManualUpdatesPresenter < ContentItemPresenter
  include ActionView::Helpers
  include ActionView::Context

  def other_metadata(_request)
    { I18n.t("formats.manuals.updated") => display_date(content_item.public_updated_at).to_s }
  end

  def presented_change_notes
    group_updates_by_year(content_item.change_notes)
  end

  def sanitize_manual_update_title(title)
    return "" if title.nil?

    strip_tags(title).gsub(I18n.t("formats.manuals.updates_amendments"), "").gsub(/\s+/, " ").strip
  end

private

  def display_date(timestamp, format = "%-d %B %Y")
    I18n.l(Time.zone.parse(timestamp), format:, locale: I18n.locale) if timestamp
  end

  def updated_at(published_at)
    Time.zone.parse(published_at).to_date
  end

  def group_updates_by_year(updates)
    updates.group_by { |update| updated_at(update["published_at"]).year }
            .sort_by { |year, _| year }
            .map { |year, grouped_updates| [year, group_updates_by_day(grouped_updates)] }.reverse
  end

  def group_updates_by_day(updates)
    updates.group_by { |update| updated_at(update["published_at"]) }
            .sort_by { |day, _| day }
            .map { |day, grouped_updates| [marked_up_date(day), group_updates_by_document(grouped_updates)] }.reverse
  end

  def group_updates_by_document(updates)
    updates.group_by { |update| update["base_path"] }
  end

  def marked_up_date(date)
    formatted_date = I18n.l(date, format: "%-d %B %Y") if date
    updates_span = content_tag("span",
                               I18n.t("formats.manuals.updates_amendments"),
                               class: "govuk-visually-hidden")

    formatted_date = "#{formatted_date} #{updates_span}"
    sanitize(formatted_date)
  end
end
