class ContentItem
  attr_reader :content_store_response, :content_store_hash, :body, :image, :description,
              :document_type, :schema, :title, :base_path, :locale, :take_part_pages

  # SCAFFOLDING: remove the override_content_store_hash parameter when full landing page
  # content items including block details are available from content-store
  def initialize(content_store_response, override_content_store_hash: nil)
    @content_store_response = content_store_response
    @content_store_hash = override_content_store_hash || content_store_response.to_hash

    @body = content_store_hash.dig("details", "body")
    @image = content_store_hash.dig("details", "image")
    @description = content_store_hash["description"]
    @document_type = content_store_hash["document_type"]
    @schema = content_store_hash["schema"]
    @title = content_store_hash["title"]
    @base_path = content_store_hash["base_path"]
    @locale = content_store_hash["locale"]
    @take_part_pages = content_store_hash.dig("links", "take_part_pages")
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

  alias_method :to_h, :content_store_hash
  delegate :cache_control, to: :content_store_response

  REGEX_IS_A = /is_an?_(.*)\?/

  def respond_to_missing?(method_name, _include_private = false)
    method_name.to_s =~ REGEX_IS_A ? true : super
  end

  def method_missing(method_name, *_args, &_block)
    if method_name.to_s =~ REGEX_IS_A
      schema == ::Regexp.last_match(1)
    else
      super
    end
  end
end
