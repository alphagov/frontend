class DetailedGuideController < ContentItemsController
  include Cacheable

  def show
    @presenter = DetailedGuidePresenter.new(content_item)
  end
end
