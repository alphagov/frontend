class FatalityNoticeController < ContentItemsController
  include Cacheable

  def show
    @content_item_presenter = ContentItemPresenter.new(content_item)
  end
end
