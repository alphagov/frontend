require "slimmer/headers"

class BusinessSupportController < ApplicationController
  include ApiRedirectable
  include Previewable

  before_filter -> { set_expiry unless viewing_draft_content? }
  before_filter -> { setup_content_item_and_navigation_helpers("/" + params[:slug]) }

  def show
    @publication = publication
    set_language_from_publication(@publication)
  end

private

  def set_language_from_publication(publication)
    I18n.locale = publication.language if publication.language
  end
end
