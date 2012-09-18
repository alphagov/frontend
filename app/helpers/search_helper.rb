module SearchHelper
  def capped_search_set_size
    [@results.count, (@top_results + @max_more_results)].min
  end

  def map_section_name(slug)
    map = {
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
    return map[slug] ? map[slug] : false
  end

  def humanize_section_name(slug)
    slug.gsub('-', ' ').capitalize
  end

  def formatted_section_name(slug)
    map_section_name(slug) ? map_section_name(slug) : humanize_section_name(slug)
  end

  PRESENTATION_FORMAT_TRANSLATION = {
    "planner" => "answer",
    "smart_answer" => "answer",
    "calculator" => "answer",
    "licence_finder" => "answer",
    "custom_application" => "answer",
    "calendar" => "answer"
  }

  def normalized_format(format)
    format ? format.gsub("-", "_") : 'unknown'
  end

  def determine_presentation_format(format)
    normalized = normalized_format(format)
    PRESENTATION_FORMAT_TRANSLATION.fetch(normalized, normalized)
  end
end
