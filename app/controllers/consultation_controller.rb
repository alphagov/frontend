class ConsultationController < ContentItemsController
  include Cacheable
  include Personalisable

  def show
    @presenter = ConsultationPresenter.new(content_item)
  end
end
