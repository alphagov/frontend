class HomepageController < ContentItemsController
  include Cacheable
  slimmer_template "gem_layout_homepage"

  def index
    set_slimmer_headers(template: "gem_layout_homepage_new")
  end

private

  def publication_class
    HomepagePresenter
  end
end
