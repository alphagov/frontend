class ContentsList
  attr_reader :items

  def initialize(hash)
    @items = hash["items"].map { |item_hash| Link.new(item_hash) }
  end
end
