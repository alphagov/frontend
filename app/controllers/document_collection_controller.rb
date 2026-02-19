class DocumentCollectionController < ContentItemsController
  include Cacheable
  include Personalisable

  def show
    @presenter = DocumentCollectionPresenter.new(content_item)
  end
end
