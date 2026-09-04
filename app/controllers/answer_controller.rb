class AnswerController < ContentItemsController
  include Cacheable

  layout "header_content_sidebar"

  def show
    @content_item_presenter = AnswerPresenter.new(content_item)
  end
end
