class HomepageController < ContentItemsController
  include Cacheable

  layout "homepage"

  def index; end
end
