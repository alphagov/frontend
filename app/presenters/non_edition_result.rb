class NonEditionResult < SearchResult
  include ERB::Util

  def to_hash
    super.merge({
      metadata: metadata,
      metadata_any?: metadata.any?,
    })
  end

  def format
    result["document_type"]
  end

  def metadata
    data = [
      formatted_public_timestamp,
      display_type,
      organisations,
    ]

    data.select(&:present?)
  end

private
  def formatted_public_timestamp
    public_timestamp && public_timestamp.to_date.strftime("%e %B %Y")
  end

  def public_timestamp
    result["public_timestamp"] || result["last_update"]
  end

  def display_type
    overrides = {
      "aaib_report" => "AAIB report",
      "cma_case" => "CMA case",
      "hmrc_manual" => "HMRC internal manual",
      "hmrc_manual_section" => "HMRC internal manual section",
      "maib_report" => "MAIB report",
      "raib_report" => "RAIB report",
    }

    overrides.fetch(format, format.humanize)
  end

  def organisations
    orgs = Array(result["organisations"]).reject(&:blank?)

    org_titles = orgs.map { |org|
      if org["acronym"] && org["acronym"] != org["title"]
        "<abbr title='#{h(org["title"])}'>#{h(org["acronym"])}</abbr>"
      else
        org["title"] || org["slug"]
      end
    }

    org_titles.join(", ")
  end
end
