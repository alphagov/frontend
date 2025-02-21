class GetInvolved < ContentItem
  attr_reader :take_part_pages

  def initialize(content_store_response)
    super
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

  def recently_opened_consultations
    query = {
      filter_content_store_document_type: "open_consultation",
      fields: "public_timestamp,end_date,title,link,organisations",
      order: "-start_date",
      count: 3,
    }

    GdsApi.search.search(query)["results"]
  end

  def recent_consultation_outcomes
    query = {
      filter_content_store_document_type: "consultation_outcome",
      filter_end_date: "to: #{Time.zone.now.to_date}",
      fields: "public_timestamp,end_date,title,link,organisations",
      order: "-end_date",
      count: 3,
    }

    GdsApi.search.search(query)["results"]
  end

  def consultations_link
    filters = %w[open_consultations closed_consultations]
    "/search/policy-papers-and-consultations?#{filters.to_query('content_store_document_type')}"
  end
end
