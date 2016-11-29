require "slimmer/headers"

class CompletedTransactionController < ApplicationController
  before_filter :redirect_if_api_request
  before_filter -> { set_expiry unless viewing_draft_content? }

  # These 2 content items have the format of 'CompletedTransaction' but do not
  # follow the convention of their slug being prefixed with '/done'`. They also
  # use a different template.
  LEGACY_SLUGS = ["transaction-finished", "driving-transaction-finished"].freeze

  def show
    setup_content_item_and_navigation_helpers("/" + params[:slug])
    @publication = PublicationPresenter.new(artefact)
    @edition = params[:edition]

    if LEGACY_SLUGS.include? params[:slug]
      render :legacy_completed_transaction
    else
      render :show
    end
  end

private

  def artefact
    @_artefact ||= ArtefactRetrieverFactory.artefact_retriever.fetch_artefact(
      params[:slug],
      params[:edition]
    )
  end

  def redirect_if_api_request
    redirect_to "/api/#{params[:slug]}.json" if request.format.json?
  end

  def viewing_draft_content?
    params.include?('edition')
  end
end
