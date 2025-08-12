class PublicationController < ContentItemsController
  include Cacheable

  def show
    @presenter = PublicationPresenter.new(content_item)
  end
end
