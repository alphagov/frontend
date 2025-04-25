class CorporateInformationPageController < ContentItemsController
  def show
    @presenter = CorporateInformationPagePresenter.new(@content_item)
    @contents_outline_presenter = ContentsOutlinePresenter.new(@presenter.contents_list_headings)
  end
end
