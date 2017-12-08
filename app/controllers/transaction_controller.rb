class TransactionController < ApplicationController
  include Cacheable
  include Navigable

  before_action :set_content_item
  before_action :deny_framing
  after_action :set_tasklist_ab_test_headers, only: [:show]

  def show
    locals = {
      locals: {
        tasklist_content: tasklist_content
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
