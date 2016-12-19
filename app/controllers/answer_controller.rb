class AnswerController < ApplicationController
  include ApiRedirectable
  include Previewable
  include Cacheable

  before_filter -> { setup_content_item_and_navigation_helpers("/" + params[:slug]) }

  def show
    @publication = publication
    set_language_from_publication
  end
end
