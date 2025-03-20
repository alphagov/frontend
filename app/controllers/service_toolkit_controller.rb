class ServiceToolkitController < ContentItemsController
  include Cacheable
  slimmer_template "gem_layout_full_width_no_footer_navigation"

  def index; end
end
