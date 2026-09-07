class DocumentCollectionController < ContentItemsController
  include Cacheable
  include Personalisable
  layout "header_content_sidebar"

  def show
    @content_item_presenter = DocumentCollectionPresenter.new(content_item)
  end
end
