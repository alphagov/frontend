class GetInvolvedController < ContentItemsController
  def content_item_slug
    request.path
  end
end
