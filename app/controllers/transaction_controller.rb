class TransactionController < ContentItemsController
  include Cacheable
  include LocaleHelper

  before_action :deny_framing

  def show
    content_item.set_current_part(params["variant"])
    @lang_attribute = lang_attribute(content_item.locale.presence)
  end

private

  def content_item_path
    "/#{params[:slug]}"
  end

  def publication_class
    TransactionPresenter
  end
end
