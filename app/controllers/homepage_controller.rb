class HomepageController < ApplicationController
  before_filter :set_expiry

  def index
    set_slimmer_headers(
      template: "homepage",
      remove_search: true,
    )

    setup_content_item("/")

    render locals: { full_width: true }
  end
end
