class ContentsOutline
  attr_reader :items

  Item = Data.define(:text, :id, :level, :items)

  def initialize(headers_array)
    @items = headers_array_to_items(headers_array)
  end

  def level_two_headers?
    nested_level_two_headers?(items)
  end

private

  def headers_array_to_items(headers_array)
    return [] if headers_array.blank?

    headers_array.map do |header|
      items = headers_array_to_items(header["headers"])
      Item.new(
        text: header["text"],
        id: header["id"],
        level: header["level"],
        items:,
      )
    end
  end

  def nested_level_two_headers?(items_array)
    items_array.detect { |item| item.level == 2 || nested_level_two_headers?(item.items) }.present?
  end
end
