class SpecialistDocumentController < ContentItemsController
  include Cacheable

  def show
    @specialist_document_presenter = SpecialistDocumentPresenter.new(content_item)
  end
end
