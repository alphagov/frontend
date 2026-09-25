class SpecialistDocumentController < ContentItemsController
  include Cacheable
  layout "header_content_sidebar"

  def show
    raise RecordNotFound unless @content_item.instance_of?(SpecialistDocument)

    @content_item_presenter = SpecialistDocumentPresenter.new(content_item)
  end
end
