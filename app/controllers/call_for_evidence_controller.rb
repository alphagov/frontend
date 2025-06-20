class CallForEvidenceController < ContentItemsController
  def show
    @presenter = CallForEvidencePresenter.new(@content_item)
  end
end
