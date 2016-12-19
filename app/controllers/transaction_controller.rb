require "slimmer/headers"

class TransactionController < ApplicationController
  include ApiRedirectable
  include Previewable

  before_filter -> { set_expiry unless viewing_draft_content? }
  before_filter -> { setup_content_item_and_navigation_helpers("/" + params[:slug]) }

  JOBSEARCH_SLUGS = ["jobsearch", "chwilio-am-swydd"].freeze

  def show
    @publication = PublicationPresenter.new(artefact)
    set_language_from_publication(@publication)
    deny_framing
    if JOBSEARCH_SLUGS.include? params[:slug]
      render :jobsearch
    else
      render :show
    end
  end

private

  def set_language_from_publication(publication)
    I18n.locale = publication.language if publication.language
  end

  def deny_framing
    response.headers['X-Frame-Options'] = 'DENY'
  end
end
