require "slimmer/headers"

class HelpController < ApplicationController
  before_filter :set_expiry

  def index
    setup_navigation_helpers("/help")

    respond_to do |format|
      format.html
      format.json { redirect_to "/api/help.json" }
    end
  end

  def tour
    setup_navigation_helpers("/tour")
    render locals: { full_width: true }
  end

protected

  def setup_navigation_helpers(base_path)
    content_item = content_store.content_item(base_path)
    @navigation_helpers = GovukNavigationHelpers::NavigationHelper.new(content_item)
  end
end
