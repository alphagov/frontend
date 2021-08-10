class HomepageController < ApplicationController
  before_action :set_expiry
  after_action :set_slimmer_template

  def index
    set_slimmer_headers(
      template: "gem_layout_full_width",
      remove_search: true,
    )

    fetch_and_setup_content_item("/")
  end

private

  def set_slimmer_template
    if explore_menu_variant_b?
      slimmer_template "gem_layout_full_width_explore_header"
    else
      slimmer_template "gem_layout_full_width"
    end
  end
end
