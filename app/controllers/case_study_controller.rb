class CaseStudyController < ContentItemsController
  def show
    @content_item_presenter = ContentItemPresenter.new(content_item)
  end
end
