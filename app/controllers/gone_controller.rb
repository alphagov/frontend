class GoneController < ContentItemsController
  include Cacheable

  skip_before_action :reroute_to_gone
  layout "header_content_sidebar"

  def show
    I18n.locale = @content_item.locale
    @content_item_presenter = GonePresenter.new(content_item)
    render status: :gone
  end
end
