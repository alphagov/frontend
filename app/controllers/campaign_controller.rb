class CampaignController < ApplicationController
  include ApiRedirectable
  include Previewable

  before_filter -> { set_expiry unless viewing_draft_content? }
  before_filter -> { setup_content_item_and_navigation_helpers("/" + params[:slug]) }, only: :show

  def show
    @publication = PublicationPresenter.new(artefact)
    render locals: { full_width: true }
  end

  def uk_welcomes
    # This is a special case. It is a hardcoded campaign which is not editable
    # in Publisher.
  end
end
