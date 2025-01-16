class SpeechController < ContentItemsController
  def show
    @presenter = SpeechPresenter.new(@content_item, view_context)
  end
end
