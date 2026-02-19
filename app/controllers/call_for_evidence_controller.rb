class CallForEvidenceController < ContentItemsController
  include Personalisable

  def show
    @presenter = CallForEvidencePresenter.new(content_item)
  end
end
