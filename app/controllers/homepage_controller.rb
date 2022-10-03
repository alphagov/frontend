class HomepageController < ContentItemsController
  include Cacheable
  slimmer_template "gem_layout_homepage"

  def index
    set_slimmer_headers(
      template: "gem_layout_homepage",
    )
  end
end
