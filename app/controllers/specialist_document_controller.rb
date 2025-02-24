class SpecialistDocumentController < ContentItemsController
  include Cacheable

  def show
    @presenter = SpecialistDocumentPresenter.new(content_item, view_context)
  end
end
