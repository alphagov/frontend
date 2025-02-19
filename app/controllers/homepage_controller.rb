class HomepageController < ContentItemsController
  include Cacheable

  slimmer_template "gem_layout_homepage"
end
