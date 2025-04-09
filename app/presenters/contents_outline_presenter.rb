class ContentsOutlinePresenter
  attr_reader :contents_outline

  def initialize(contents_outline)
    @contents_outline = contents_outline
  end

  def for_contents_list_component
    contents_outline.items.map { |item| item_to_component_h(item) }
  end

private

  def item_to_component_h(item)
    {
      href: "##{item.id}",
      text: item.text,
      items: item.items.empty? ? nil : item.items.map { |subitem| item_to_component_h(subitem) },
    }.compact
  end
end
