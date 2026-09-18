class ConsultationController < ContentItemsController
  include Cacheable
  include Personalisable
  layout "header_content_sidebar"

  def show
    @content_item_presenter = ConsultationPresenter.new(content_item)
  end
end
