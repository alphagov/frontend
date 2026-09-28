class TransactionController < ContentItemsController
  include Cacheable
  include LocaleHelper

  layout "header_content_sidebar"

  def show
    content_item.set_variant(params["variant"])
    @content_item_presenter = TransactionPresenter.new(content_item)
  end

private

  def content_item_path
    "/#{params[:slug]}"
  end
end
