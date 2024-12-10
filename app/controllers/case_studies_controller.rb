class CaseStudiesController < ContentItemsController
  def show
    @case_study_presenter = ContentItemModelPresenter.new(content_item)
    @metadata_presenter = MetadataPresenter.new(content_item)
  end
end
