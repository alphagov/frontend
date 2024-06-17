class TransactionController < ContentItemsController
  include Cacheable
  include LocaleHelper

  force_html_format

  before_action :deny_framing

  def show
    publication.variant_slug = params["variant"]
    @lang_attribute = lang_attribute(publication.locale.presence)
  end

private

  def publication_class
    TransactionPresenter
  end
end
