class ContentItemPresenter
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def page_title
    content_item.withdrawn? ? "[Withdrawn] #{content_item.title}" : content_item.title
  end
end
