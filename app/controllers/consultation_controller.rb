class ConsultationController < ContentItemsController
  include Cacheable
  include Personalisable

  def show
    @content_item_presenter = ConsultationPresenter.new(content_item)
  end
end
