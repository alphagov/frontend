class CorporateInformationPageController < ContentItemsController
  layout "header_content_sidebar"

  def show
    @content_item_presenter = CorporateInformationPagePresenter.new(@content_item)
  end
end
