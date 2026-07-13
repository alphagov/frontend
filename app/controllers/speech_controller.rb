class SpeechController < ContentItemsController
  def show
    @content_item_presenter = SpeechPresenter.new(content_item)
  end
end
