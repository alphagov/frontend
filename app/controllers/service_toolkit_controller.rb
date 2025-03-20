class ServiceToolkitController < ContentItemsController
  include Cacheable
  slimmer_template "gem_layout_full_width"

  def index; end
end
