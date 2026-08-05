class FatalityNoticeController < ContentItemsController
  include Cacheable

  layout "header_content_sidebar"

  def show
    @content_item_presenter = FatalityNoticePresenter.new(content_item)
  end
end
