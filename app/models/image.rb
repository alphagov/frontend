class Image
  attr_reader :alt, :caption, :content_type, :sources, :type

  def initialize(info)
    @alt = info["alt"]
    @caption = info["caption"]
    @content_type = info["content_type"]
    @sources = info["sources"]
    @type = info["type"]
  end

  def src(key: "s300")
    sources[key]
  end
end
