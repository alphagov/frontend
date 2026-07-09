class CorporateInformationPageController < ContentItemsController
  def show
    @content_item_presenter = CorporateInformationPagePresenter.new(@content_item)
  end
end
