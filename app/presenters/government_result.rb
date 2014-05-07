class GovernmentResult < SearchResult
  include ERB::Util
  result_accessor :public_timestamp, :display_type, :indexable_content

  def to_hash
    super.merge({
      attributes: attributes,
      attributes_any?: attributes.any?,
      sections: sections,
      sections_present?: sections.present?,
      government: true
    })
  end

  def display_links?
    ! %w{
      /government/organisations/deputy-prime-ministers-office
      /government/organisations/prime-ministers-office-10-downing-street}.include?(self.link)
  end

  def attributes
    out = []
    out << display_timestamp if public_timestamp.present?
    if display_type.present?
      out << display_type
    elsif %w{ corporate_information document_series }.include?(format)
      out << format.humanize
    end
    out << display_organisations(organisations) if organisations.any?
    out << display_world_locations if world_locations.any?
    out
  end

  def sections
    case format
    when 'minister' then
      [
        { hash: 'responsibilities', title: 'Responsibilities' },
        { hash: 'current-role-holder', title: 'Current role holder' },
      ]
    when 'organisation' then
      if display_links?
        [
          { hash: 'topics', title: 'What we do' },
          { hash: 'policies', title: 'Policies' },
          { hash: 'org-contacts', title: 'Contact details' },
          { hash: 'ministers', title: 'Ministers' },
        ]
      end
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

  def organisations
    fetch_multi_valued_field("organisations")
  end

  def has_organisations?
    organisations.any?
  end

  def topics
    fetch_multi_valued_field("topics")
  end

  def has_topics?
    topics.any?
  end

  def world_locations
    fetch_multi_valued_field("world_locations")
  end

  def has_world_locations?
    world_locations.any?
  end

  def document_series
    fetch_multi_valued_field("document_series")
  end

  def has_document_series?
    document_series.any?
  end

  def display_timestamp
    self.public_timestamp.to_date.strftime("%e %B %Y")
  end


  def display_topics
    display(topics)
  end

  def display_world_locations
    if world_locations.length > 1
      "multiple locations"
    else
      display(world_locations)
    end
  end

  def display_document_series
    display(document_series)
  end

  def description
    if format == "detailed_guidance"
      result["description"]
    elsif format == "organisation"
      "The home of #{title} on GOV.UK. #{display_a_description}"
    else
      display_a_description
    end
  end

  def display_a_description
    if result["description"].present?
      result["description"].truncate(215, :separator => " ")
    elsif result["indexable_content"].present?
      result["indexable_content"].truncate(215, :separator => " ")
    else
      nil
    end
  end

private

  def display(multi_valued_field)
    multi_valued_field.map do |field|
      field["acronym"] || field["title"] || field["slug"]
    end.join(", ")
  end

  def fetch_multi_valued_field(field_name)
    if result[field_name].present?
      result[field_name].reject(&:blank?)
    else
      []
    end
  end

  def display_organisations(organisations)
    organisations.map do |organisation|
      if organisation["acronym"] && (organisation["acronym"] != organisation["title"])
        "<abbr title='#{h(organisation["title"])}'>#{h(organisation["acronym"])}</abbr>"
      else
        organisation["title"] || organisation["slug"]
      end
    end.join(", ")
  end
end
