class DetailedGuideController < ContentItemsController
  include Cacheable
  include Personalisable

  def show
    @content_item_presenter = DetailedGuidePresenter.new(content_item)
  end
end
