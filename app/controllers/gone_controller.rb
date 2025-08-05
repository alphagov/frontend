class GoneController < ContentItemsController
  include Cacheable

  skip_before_action :reroute_to_gone

  def show
    I18n.locale = @content_item.locale
  end
end
