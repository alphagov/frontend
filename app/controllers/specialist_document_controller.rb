class SpecialistDocumentController < ContentItemsController
  include Cacheable

  def show
    @presenter = SpecialistDocumentPresenter.new(content_item)
    @contents_outline_presenter = ContentsOutlinePresenter.new(content_item.headers)
  end
end
