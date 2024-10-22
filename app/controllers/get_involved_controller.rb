class GetInvolvedController < ContentItemsController
  def content_item_slug
    request.path
  end

  def show
    @presenter = GetInvolvedPresenter.new(@content_item)
  end
end
