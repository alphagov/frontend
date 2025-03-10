class SpeechController < ContentItemsController
  def show
    @presenter = SpeechPresenter.new(content_item)
  end
end
