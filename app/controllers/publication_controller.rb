class PublicationController < ContentItemsController
  include Cacheable
  include Personalisable

  def show
    @content_item_presenter = PublicationPresenter.new(content_item)
  end
end
