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

  PASS_THROUGH_KEYS = [
    :presentation_format, :link, :title, :description,
    :format, :humanized_format, :es_score
  ]
  PASS_THROUGH_KEYS.each do |key|
    define_method key do
      result[key.to_s]
    end
  end

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
  PASS_THROUGH_KEYS = [:public_timestamp, :organisations, :location, :display_type, :topics]

  PASS_THROUGH_KEYS.each do |key|
    define_method key do
      result[key.to_s]
    end
  end

  def has_departments?
    if self.organisations.present? and self.organisations.count > 0
      true
    else
      false
    end
  end

  def display_timestamp
    self.public_timestamp.to_date.strftime("%e %B %Y")
  end

  def display_topics
    self.topics.to_s
  end

  def display_departments
    if self.organisations.present?
      titles = self.organisations.map do |organisation|
        organisation["title"]
      end
      titles.join(",")
    end
  end

  def location
    locations = ['UK']
    locations.length > 1 ? 'multiple locations' : locations[0]
  end
end

