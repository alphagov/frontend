class TransactionController < ContentItemsController
  include Cacheable
  include LocaleHelper

  before_action :deny_framing

  def show
    @lang_attribute = lang_attribute(publication.locale.presence)
    content_item.set_current_part(params["variant"])
  end

private

  def content_item_path
    "/#{params[:slug]}"
  end

  def publication_class
    TransactionPresenter
  end
end
