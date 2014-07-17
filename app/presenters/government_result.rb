class GovernmentResult < SearchResult
  include ERB::Util
  result_accessor :display_type

  def to_hash
    super.merge({
      metadata: metadata,
      metadata_any?: metadata.any?,
      sections: sections,
      sections_present?: sections.present?,
      government: true
    })
  end

  def metadata
    out = []
    out << public_timestamp if public_timestamp.present?
    if display_type.present?
      out << display_type
    elsif %w{ corporate_information document_series }.include?(format)
      out << format.humanize
    end
    out << organisations if organisations.present?
    out << world_locations if world_locations.present?
    out
  end

  def sections
    case format
    when 'minister' then
      [
        { hash: 'responsibilities', title: 'Responsibilities' },
        { hash: 'current-role-holder', title: 'Current role holder' },
      ]
    when 'person' then
      [
        { hash: 'biography', title: 'Biography' },
        { hash: 'current-roles', title: 'Roles' },
      ]
    when 'world_location' then
      [
        { hash: 'worldwide-priorities', title: 'Priorities' },
        { hash: 'organisations', title: "Organisations in #{title}" },
      ]
    when 'worldwide_organisation' then
      [
        { hash: 'our-services', title: 'Services' },
        { hash: 'contact-us', title: 'Contact details' },
      ]
    end
  end

  def title
    if format == 'organisation' && result["organisation_state"] == 'closed'
      "Closed organisation: " + result["title"]
    else
      result["title"]
    end
  end

  def public_timestamp
    result["public_timestamp"].to_date.strftime("%e %B %Y") if result["public_timestamp"]
  end

  def description
    description = nil
    if result["description"].present?
      description = result["description"]
    end

    description = description.truncate(215, :separator => " ") if description

    if format == "organisation" && result["organisation_state"] != 'closed'
      "The home of #{result["title"]} on GOV.UK. #{description}"
    else
      description
    end
  end

private

  def world_locations
    locations = fetch_multi_valued_field("world_locations")
    if locations.length > 1
      "multiple locations"
    elsif locations.length == 1
      locations.map do |field|
        field["acronym"] || field["title"] || field["slug"]
      end.join(", ")
    end
  end

  def fetch_multi_valued_field(field_name)
    if result[field_name].present?
      result[field_name].reject(&:blank?)
    else
      []
    end
  end

  def organisations
    fetch_multi_valued_field("organisations").map do |organisation|
      if organisation["acronym"] && (organisation["acronym"] != organisation["title"])
        "<abbr title='#{h(organisation["title"])}'>#{h(organisation["acronym"])}</abbr>"
      else
        organisation["title"] || organisation["slug"]
      end
    end.join(", ")
  end
end
