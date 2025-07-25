class GoneController < ContentItemsController
  include Cacheable
  def show
    I18n.locale = @content_item.locale
  end
end