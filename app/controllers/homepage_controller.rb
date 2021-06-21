class HomepageController < ApplicationController
  before_action :set_expiry

  def index
    set_slimmer_headers(
      template: "gem_layout_full_width",
      remove_search: true,
    )

    fetch_and_setup_content_item("/")
  end
end
