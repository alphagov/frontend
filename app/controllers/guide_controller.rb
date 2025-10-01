class GuideController < ContentItemsController
  include Cacheable

  def show
    @presenter = GuidePresenter.new(content_item)
  end

private

  def content_item_path
    "/#{params[:slug]}"
  end
end
