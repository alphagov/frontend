class ContentItemPresenter
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def contributor_links
    content_item.contributors.map do |content_item|
      { text: content_item.title, path: content_item.base_path }
    end
  end
end
