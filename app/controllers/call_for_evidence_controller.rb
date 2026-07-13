class CallForEvidenceController < ContentItemsController
  include Personalisable

  def show
    @content_item_presenter = CallForEvidencePresenter.new(content_item)
  end
end
