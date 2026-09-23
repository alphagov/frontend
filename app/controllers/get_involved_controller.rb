class GetInvolvedController < ContentItemsController
  def show
    # GetInvolved is a special route, so we have to cast it into the proper model
    @content_item = GetInvolved.new(content_item.content_store_response)
    @content_item_presenter = GetInvolvedPresenter.new(@content_item)
    render layout: "header_content_sidebar"
  end
end
