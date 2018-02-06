class TransactionController < ApplicationController
  include Cacheable
  include Navigable

  before_action :set_content_item
  before_action :deny_framing

  def show
    locals = {
      locals: {
        step_nav_content: current_step_nav
      }
    }
    render :show, locals
  end

  def jobsearch; end

private

  def set_content_item
    super(TransactionPresenter)
  end

  def deny_framing
    response.headers['X-Frame-Options'] = 'DENY'
  end
end
