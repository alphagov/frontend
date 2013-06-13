class SearchResult
  SECTION_NAME_TRANSLATION = {
    "life-in-the-uk" => "Life in the UK",
    "council-tax" => "Council Tax",
    "housing-benefits-grants-and-schemes" => "Housing benefits, grants and schemes",
    "work-related-benefits-and-schemes" => "Work-related benefits and schemes",
    "buying-selling-a-vehicle" => "Buying/selling a vehicle",
    "owning-a-car-motorbike" => "Owning a car/motorbike",
    "council-and-housing-association-homes" => "Council and housing association homes",
    "animals-food-and-plants" => "Animals, food and plants",
    "mot" => "MOT",
    "mot-insurance" => "MOT insurance",
    "Inside Government" => "Inside Government"
  }

  attr_accessor :result

  def initialize(result)
    @result = result.stringify_keys!
  end

  def ==(other)
    other.respond_to?(:link) && (link == other.link)
  end

  def self.result_accessor(*keys)
    keys.each do |key|
      define_method key do
        result[key.to_s]
      end
    end
  end

  result_accessor :presentation_format, :link, :title, :description, :format, :humanized_format, :es_score

  # Avoid the mundanity of creating these all by hand by making
  # dynamic method and accessors.
  %w(section subsection subsubsection).each do |key|
    define_method "formatted_#{key}_name" do
      mapped_name(send(key)) || humanized_name(send(key))
    end

    define_method key do
      result[key]
    end
  end

  protected

  def mapped_name(var)
    return SECTION_NAME_TRANSLATION[var] ? SECTION_NAME_TRANSLATION[var] : false
  end

  def humanized_name(name)
    name.gsub('-', ' ').capitalize
  end
end

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
    display(world_locations)
  end

  def display_document_series
    display(document_series)
  end

  def display_a_description
    if self.description.present?
      self.description.truncate(150, :seperator => " ")
    elsif self.indexable_content.present?
      self.indexable_content.truncate(150, :seperator => " ")
    else
      nil
    end
  end

end

