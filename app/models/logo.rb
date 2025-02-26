class Logo
  attr_reader :crest, :formatted_title

  def initialize(logo)
    @crest = logo["crest"]
    @formatted_title = logo["formatted_title"]
  end
end