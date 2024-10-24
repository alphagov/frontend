class HelpPageController < ContentItemsController
  def show; end

private

  def content_item_slug
    request.path
  end
end
