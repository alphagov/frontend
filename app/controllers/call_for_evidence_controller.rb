class CallForEvidenceController < ContentItemsController
  include Personalisable

  layout "header_content_sidebar"

  def show
    @content_item_presenter = CallForEvidencePresenter.new(content_item)
  end
end
