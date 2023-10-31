class HomepageController < ContentItemsController
  include Cacheable
  slimmer_template "gem_layout_homepage"

  def index
    set_slimmer_headers(
      template: new_design? ? "gem_layout_homepage_new" : "gem_layout_homepage",
    )
  end

  helper_method :new_design?

  def new_design?
    true
  end

  def integration_feature_flag?
    ENV["NEW_DESIGN"].present?
  end
end
