class TransactionController < ApplicationController
  include ApiRedirectable
  include Previewable
  include Cacheable
  include Navigable

  before_filter :set_publication

  JOBSEARCH_SLUGS = ["jobsearch", "chwilio-am-swydd"].freeze

  def show
    deny_framing
    if JOBSEARCH_SLUGS.include? params[:slug]
      render :jobsearch
    else
      render :show
    end
  end

private

  def deny_framing
    response.headers['X-Frame-Options'] = 'DENY'
  end
end
