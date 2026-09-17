class SpeechController < ContentItemsController
  layout "header_content_sidebar"

  def show
    @content_item_presenter = SpeechPresenter.new(content_item)
  end
end
