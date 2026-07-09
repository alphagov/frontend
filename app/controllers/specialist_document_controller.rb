class SpecialistDocumentController < ContentItemsController
  include Cacheable

  def show
    raise RecordNotFound unless @content_item.instance_of?(SpecialistDocument)

    @content_item_presenter = SpecialistDocumentPresenter.new(content_item)
  end
end
