class GuideController < ContentItemsController
  include Cacheable

  def show
    content_item.set_current_part(params[:part])

    redirect_to content_item.base_path if content_item.current_part.blank?

    @presenter = GuidePresenter.new(content_item)

    request.variant = :print if params[:variant] == :print
  end

private

  def content_item_path
    "/#{params[:slug]}"
  end
end
