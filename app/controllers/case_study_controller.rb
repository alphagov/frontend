class CaseStudyController < ContentItemsController
  layout "header_content_sidebar"

  def show
    @content_item_presenter = CaseStudyPresenter.new(content_item)
  end
end
