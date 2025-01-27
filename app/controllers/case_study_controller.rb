class CaseStudyController < ContentItemsController
  def show
    @case_study_presenter = ContentItemPresenter.new(content_item)
  end
end
