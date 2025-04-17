class DetailedGuideController < ContentItemsController
  def show
    @detailed_guide_presenter = ContentItemPresenter.new(content_item)
  end
end
