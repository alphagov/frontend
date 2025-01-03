class TransactionController < ContentItemsController
  include Cacheable
  include LocaleHelper

  before_action :deny_framing

  def show
    publication.variant_slug = params["variant"]
    @lang_attribute = lang_attribute(publication.locale.presence)
  end

private

  def content_item_path
    "/#{params[:slug]}"
  end

  def publication_class
    TransactionPresenter
  end
end
