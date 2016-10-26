require "slimmer/headers"

class HelpController < ApplicationController
  before_filter :set_expiry

  def index
    setup_content_item_and_navigation_helpers("/help")

    respond_to do |format|
      format.html
      format.json { redirect_to "/api/help.json" }
    end
  end

  def tour
    setup_content_item_and_navigation_helpers("/tour")
    render locals: { full_width: true }
  end
end
