class HomepageController < ContentItemsController
  include Cacheable

  layout "full_width"
  before_action :set_homepage_layout

private

  def set_homepage_layout
    @homepage_layout = true
  end
end
