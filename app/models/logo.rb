class Logo
  attr_reader :crest, :formatted_title, :image

  def initialize(logo)
    @image = get_image(logo["image"])
    @crest = logo["crest"]
    @formatted_title = logo["formatted_title"]
  end

  def get_image(logo_image)
    return unless logo_image

    OpenStruct.new(
      alt_text: logo_image["alt_text"],
      url: logo_image["url"],
    )
  end
end