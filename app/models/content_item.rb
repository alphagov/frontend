class ContentItem
  attr_reader :content_store_response, :body, :image, :description, :document_type, :title, :base_path, :locale, :take_part_pages

  def initialize(content_store_response)
    @content_store_response = content_store_response
    @body = content_store_response.dig("details", "body")
    @image = content_store_response.dig("details", "image")
    @description = content_store_response["description"]
    @document_type = content_store_response["document_type"]
    @title = content_store_response["title"]
    @base_path = content_store_response["base_path"]
    @locale = content_store_response["locale"]
    @take_part_pages = content_store_response.dig("links", "take_part_pages")
  end

  def open_consultation_count
    GdsApi.search.search({ filter_content_store_document_type: "open_consultation", count: 0 })["total"]
  end

  def closed_consultation_count
    query = {
      filter_content_store_document_type: "closed_consultation",
      filter_end_date: "from: #{1.year.ago}",
      count: 0,
    }

    GdsApi.search.search(query)["total"]
  end

  def next_closing_consultation
    query = {
      filter_content_store_document_type: "open_consultation",
      filter_end_date: "from: #{Time.zone.now.to_date}",
      fields: "end_date,title,link",
      order: "end_date",
      count: 1,
    }

    GdsApi.search.search(query)["results"].first
  end

  def recently_opened
    filtered_links(recently_opened_consultations, I18n.t("get_involved.closes"))
  end

  def recent_outcomes
    filtered_links(recent_consultation_outcomes, I18n.t("get_involved.closed"))
  end

  def time_until_closure(consultation)
    days_left = (consultation["end_date"].to_date - Time.zone.now.to_date).to_i
    case days_left
    when :negative?.to_proc
      I18n.t("get_involved.closed")
    when :zero?.to_proc
      I18n.t("get_involved.closing_today")
    when 1
      I18n.t("get_involved.closing_tomorrow")
    else
      I18n.t("get_involved.days_left", number_of_days: days_left)
    end
  end

  def consultations_link
    filters = %w[open_consultations closed_consultations]
    "/search/policy-papers-and-consultations?#{filters.to_query('content_store_document_type')}"
  end

private

  def recently_opened_consultations
    query = {
      filter_content_store_document_type: "open_consultation",
      fields: "end_date,title,link,organisations",
      order: "-start_date",
      count: 3,
    }

    GdsApi.search.search(query)["results"]
  end

  def recent_consultation_outcomes
    query = {
      filter_content_store_document_type: "consultation_outcome",
      filter_end_date: "to: #{Time.zone.now.to_date}",
      fields: "end_date,title,link,organisations",
      order: "-end_date",
      count: 3,
    }

    GdsApi.search.search(query)["results"]
  end

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

  def ordered_related_items(links)
    return [] if links["ordered_related_items_overrides"].present?

    links["ordered_related_items"].presence || links.fetch(
      "suggested_ordered_related_items", []
    )
  end

  delegate :to_h, to: :content_store_response
  delegate :cache_control, to: :content_store_response
end
