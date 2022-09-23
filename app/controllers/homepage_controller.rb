class HomepageController < ContentItemsController
  include Cacheable
  slimmer_template "gem_layout_full_width"

  def index
    set_slimmer_headers(
      template: "gem_layout_full_width",
      show_mirror_banner: request.headers["X-Slimmer-Show-Mirror-Banner"],
      remove_search: true,
    )
  end
end
