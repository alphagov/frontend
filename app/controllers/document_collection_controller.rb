class DocumentCollectionController < ContentItemsController
  include Cacheable

  def show
    @presenter = DocumentCollectionPresenter.new(content_item)
  end
end
