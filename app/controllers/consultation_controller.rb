class ConsultationController < ContentItemsController
  include Cacheable

  def show
    @presenter = ConsultationPresenter.new(content_item)
  end
end
