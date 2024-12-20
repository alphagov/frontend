class TransactionController < ContentItemsController
  include Cacheable
  include LocaleHelper

  before_action :deny_framing

  def show
    content_item.set_variant(params["variant"])
    @lang_attribute = lang_attribute(publication.locale.presence)
    @transaction_presenter = TransactionPresenter.new(content_item)
  end

private

  def content_item_path
    "/#{params[:slug]}"
  end

  def publication
    content_item
  end
end
