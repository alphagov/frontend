require "slimmer/headers"

class AnswerController < ApplicationController
  include ApiRedirectable
  include Previewable

  before_filter -> { set_expiry unless viewing_draft_content? }
  before_filter -> { setup_content_item_and_navigation_helpers("/" + params[:slug]) }

  def show
    @publication = publication
    set_language_from_publication
  end
end
