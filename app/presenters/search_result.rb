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
    "mot" => "MOT"
  }

  attr_accessor :result

  def initialize(result)
    @result = result.stringify_keys!
  end

  PASS_THROUGH_KEYS = [
    :presentation_format, :link, :title, :description,
    :format, :humanized_format
  ]
  PASS_THROUGH_KEYS.each do |key|
    define_method key do
      result[key.to_s]
    end
  end

  def formatted_section_name
    mapped_section_name ? mapped_section_name : humanized_section_name
  end

  def section
    if result['format'] == 'specialist_guidance'
      'specialist'
    else
      result['section']
    end
  end

  protected
  def normalized_format
    result['format'] ? result['format'].gsub("-", "_") : 'unknown'
  end

  def mapped_section_name
    return SECTION_NAME_TRANSLATION[section] ? SECTION_NAME_TRANSLATION[section] : false
  end

  def humanized_section_name
    section.gsub('-', ' ').capitalize
  end
end
