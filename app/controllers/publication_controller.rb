class PublicationController < ContentItemsController
  include Cacheable
  include Personalisable

  def show
    @presenter = PublicationPresenter.new(content_item)
  end
end
