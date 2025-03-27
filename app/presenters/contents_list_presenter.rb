class ContentsListPresenter
  def initialize(contents_list)
    @contents_list = contents_list
  end

  def to_component
    items.map { |item| { "href" => item.href, "text" => items.text } }
  end
end
