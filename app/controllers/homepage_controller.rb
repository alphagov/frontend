class HomepageController < ContentItemsController
  include Cacheable
  slimmer_template "gem_layout_full_width"

  def index
    set_slimmer_headers(
      template: "gem_layout_full_width",
      remove_search: true,
    )
  end

  def contentful
    set_slimmer_headers(
      template: "gem_layout_full_width",
      remove_search: true,
    )
  end
end
