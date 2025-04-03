class ContentsList
  attr_reader :items

  def initialize(array)
    @items = array.map { |item_hash| Link.new(item_hash) }
  end
end
