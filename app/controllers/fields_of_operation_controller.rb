class FieldsOfOperationController < ContentItemsController
  include Cacheable

  layout "header_content_sidebar"

  def index
    @content_item_presenter = ContentItemPresenter.new(content_item)
  end
end
