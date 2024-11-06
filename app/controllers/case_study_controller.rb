class CaseStudyController < ContentItemsController
  def show
    @case_study_presenter = ContentItemModelPresenter.new(content_item)
  end
end
