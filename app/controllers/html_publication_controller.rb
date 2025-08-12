class HtmlPublicationController < ContentItemsController
  include Cacheable

  def show
    @presenter = HtmlPublicationPresenter.new(content_item)
  end
end
