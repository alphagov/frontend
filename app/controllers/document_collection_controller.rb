class DocumentCollectionController < ContentItemsController
  include Cacheable

  def show
    @presenter = DocumentCollectionPresenter(content_item)
  end
end
