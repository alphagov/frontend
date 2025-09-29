class GuideController < ContentItemsController
  include Cacheable

  def show
    content_item.set_current_part(params[:part])

    @presenter = GuidePresenter.new(content_item)
  end

private

  def content_item_path
    "/#{params[:slug]}"
  end
end
