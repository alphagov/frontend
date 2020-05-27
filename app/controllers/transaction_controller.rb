class TransactionController < ApplicationController
  include Cacheable
  include Navigable

  include LocaleHelper

  before_action :set_content_item
  before_action :deny_framing

  def show
    @lang_attribute = lang_attribute(@publication.locale.presence)
  end

private

  def set_content_item
    super(TransactionPresenter)
    @publication.variant_slug = params["variant"]
  end

  def deny_framing
    response.headers["X-Frame-Options"] = "DENY"
  end
end
