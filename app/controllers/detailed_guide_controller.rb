class DetailedGuideController < ContentItemsController
  include Cacheable
  include Personalisable

  def show
    @presenter = DetailedGuidePresenter.new(content_item)
  end
end
