class ContentsOutlinePresenter
  attr_reader :contents_outline

  def initialize(contents_outline)
    @contents_outline = contents_outline
  end

  def for_contents_list_component
    items_to_component_h(contents_outline.items)
  end

private

  def items_to_component_h(items)
    items.map do |item|
      {
        href: "##{item.id}",
        text: item.text.gsub(/:$/, ""),
        items: items_to_component_h(item.items),
      }
    end
  end
end
