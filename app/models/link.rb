class Link
  attr_reader :href, :text

  def initialize(hash)
    @href = hash["href"]
    @text = hash["text"]
  end
end
