class TransactionController < ApplicationController
  include Cacheable
  include Navigable
  include EducationNavigationABTestable
  include TasklistABTestable
  include TasklistHeaderABTestable

  before_action :set_content_item
  before_action :deny_framing

  def show
    render :show, locals: { tasklist: configure_current_task(TasklistContent.learn_to_drive_config) }
  end

  def jobsearch
  end

private

  def set_content_item
    super(TransactionPresenter)
  end

  def deny_framing
    response.headers['X-Frame-Options'] = 'DENY'
  end
end
