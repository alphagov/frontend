class FieldOfOperationController < ContentItemsController
  include Cacheable

  layout "header_sidebar_content"

  def show
    @presenter = FieldOfOperationPresenter.new(@content_item)
  end
end
