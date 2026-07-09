class DocumentCollectionController < ContentItemsController
  include Cacheable
  include Personalisable

  def show
    @content_item_presenter = DocumentCollectionPresenter.new(content_item)
  end
end
