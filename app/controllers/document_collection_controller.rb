class DocumentCollectionController < ContentItemsController
  include Cacheable

  helper_method :logged_in?

  def show
    @presenter = DocumentCollectionPresenter.new(content_item)
  end
end
