class CaseStudyController < ContentItemsController
  def show
    @case_study_presenter = CaseStudyPresenter.new(content_item, view_context)
  end
end
