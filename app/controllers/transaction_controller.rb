class TransactionController < ApplicationController
  include ApiRedirectable
  include Previewable

  before_filter -> { set_expiry unless viewing_draft_content? }
  before_filter -> { setup_content_item_and_navigation_helpers("/" + params[:slug]) }

  JOBSEARCH_SLUGS = ["jobsearch", "chwilio-am-swydd"].freeze

  def show
    @publication = publication
    set_language_from_publication
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
