class SearchResult
  SCHEME_PATTERN = %r{^https?://}

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

  # External links have a truncated version of their URLs displayed on the
  # results page, but there's little benefit to displaying the URL scheme
  def display_link
    link.sub(SCHEME_PATTERN, '').truncate(48)
  end

  protected

  def mapped_name(var)
    return SECTION_NAME_TRANSLATION[var] ? SECTION_NAME_TRANSLATION[var] : false
  end

  def humanized_name(name)
    name.gsub('-', ' ').capitalize
  end
end
