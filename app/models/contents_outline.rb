class ContentsOutline
  attr_reader :items

  Item = Data.define(:text, :id, :level, :items)

  def initialize(headers_array)
    @items = headers_array_to_items(headers_array)
  end

private

  def headers_array_to_items(headers_array)
    (headers_array || []).map do |header|
      subitems = header["headers"] ? headers_array_to_items(header["headers"]) : []
      Item.new(text: header["text"].gsub(/:$/, ""), id: header["id"], level: header["level"], items: subitems)
    end
  end
end
