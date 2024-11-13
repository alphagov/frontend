class GetInvolvedController < ContentItemsController
  def show
    @presenter = GetInvolvedPresenter.new(@content_item)
  end
end
