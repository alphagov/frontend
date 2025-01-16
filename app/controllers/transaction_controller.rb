class TransactionController < ContentItemsController
  include Cacheable
  include LocaleHelper

  before_action :deny_framing

  def show
    content_item.set_variant(params["variant"])
    @transaction_presenter = TransactionPresenter.new(content_item)
  end

private

  def content_item_path
    "/#{params[:slug]}"
  end
end
