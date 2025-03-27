class ContentsListPresenter
  def initialize(contents_list)
    @contents_list = contents_list
  end

  def to_component
    @contents_list.items.map { |item| { href: item.href, text: item.text } }
  end
end
