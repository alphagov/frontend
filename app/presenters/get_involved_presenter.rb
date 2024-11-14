class GetInvolvedPresenter
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def recently_opened
    filtered_links(content_item.recently_opened_consultations, I18n.t("formats.get_involved.closes"))
  end

  def recent_outcomes
    filtered_links(content_item.recent_consultation_outcomes, I18n.t("formats.get_involved.closed"))
  end

  def time_until_next_closure
    days_left = (content_item.next_closing_consultation["end_date"].to_date - Time.zone.now.to_date).to_i
    if days_left.negative?
      I18n.t("formats.get_involved.closed")
    elsif days_left.zero?
      I18n.t("formats.get_involved.closing_today")
    elsif days_left == 1
      I18n.t("formats.get_involved.closing_tomorrow")
    else
      I18n.t("formats.get_involved.days_left", number_of_days: days_left)
    end
  end

private

  def filtered_links(array, close_status)
    array.map do |item|
      {
        link: {
          text: item["title"],
          path: item["link"],
          description: "#{close_status} #{item['end_date'].to_date.strftime('%d %B %Y')}",
        },
        metadata: {
          public_updated_at: Time.zone.parse(org_time(item)),
          document_type: org_acronym(item),
        },
      }
    end
  end

  def org_time(item)
    item["organisations"].map { |org|
      org["public_timestamp"]
    }.join(", ")
  end

  def org_acronym(item)
    item["organisations"].map { |org|
      org["acronym"]
    }.join(", ")
  end
end
