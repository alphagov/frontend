class GuideController < ContentItemsController
  include Cacheable

  def show; end

private

  def content_item_path
    "/#{params[:slug]}"
  end
end
