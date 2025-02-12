class FatalityNoticeController < ContentItemsController
  include Cacheable

  def show
    @presenter = ContentItemPresenter.new(content_item)
  end
end
