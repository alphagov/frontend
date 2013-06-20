class GovernmentResult < SearchResult
  result_accessor :public_timestamp, :display_type, :indexable_content

  def fetch_multi_valued_field(field_name)
    if result[field_name].present?
      result[field_name].reject(&:blank?)
    else
      []
    end
  end

  def display_links?
    ! %w{
      /government/organisations/deputy-prime-ministers-office
      /government/organisations/prime-ministers-office-10-downing-street}.include?(self.link)
  end

  def departments
    fetch_multi_valued_field("organisations")
  end

  def has_departments?
    departments.any?
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

  def display(multi_valued_field)
    multi_valued_field.map do |field|
      field["acronym"] || field["title"] || field["slug"]
    end.join(", ")
  end

  def display_topics
    display(topics)
  end

  def display_departments
    display(departments)
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

  def display_a_description
    if self.description.present?
      self.description.truncate(215, :separator => " ")
    elsif self.indexable_content.present?
      self.indexable_content.truncate(215, :separator => " ")
    else
      nil
    end
  end
end
