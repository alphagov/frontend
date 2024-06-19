class TransactionController < ContentItemsController
  include Cacheable
  include LocaleHelper

  before_action :deny_framing
  before_action :html_only

  def show
    publication.variant_slug = params["variant"]
    @lang_attribute = lang_attribute(publication.locale.presence)
  end

private

  def publication_class
    TransactionPresenter
  end
end
