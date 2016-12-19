require "slimmer/headers"

class CompletedTransactionController < ApplicationController
  include ApiRedirectable
  include Previewable

  before_filter -> { set_expiry unless viewing_draft_content? }
  before_filter -> { setup_content_item_and_navigation_helpers("/" + params[:slug]) }

  # These 2 legacy completed transactions are linked to from multiple
  # transactions. The user satisfaction survey should not be shown for these as
  # it would generate noisy data for the linked organisation.
  LEGACY_SLUGS = [
    "done/transaction-finished",
    "done/driving-transaction-finished"
  ].freeze

  def show
    @publication = PublicationPresenter.new(artefact)
  end

private

  helper_method :show_survey?

  def show_survey?
    LEGACY_SLUGS.exclude?(params[:slug])
  end
end
