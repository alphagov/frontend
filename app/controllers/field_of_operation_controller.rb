class FieldOfOperationController < ContentItemsController
  include Cacheable
  def show
    @presenter = FieldOfOperationPresenter.new(@content_item)
  end
end
