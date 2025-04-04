class CorporateInformationPageController < ContentItemsController
  def show
    @presenter = CorporateInformationPagePresenter.new(@content_item)
  end
end
