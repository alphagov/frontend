class TransactionController < ApplicationController
  include Cacheable
  include Navigable

  before_action :set_content_item
  before_action :deny_framing

  def show
  end

private

  def set_content_item
    super(TransactionPresenter)
  end

  def deny_framing
    response.headers['X-Frame-Options'] = 'DENY'
  end
end
