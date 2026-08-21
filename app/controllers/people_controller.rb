class PeopleController < ContentItemsController
  include Cacheable

  def show
    @content_item_presenter = PersonPresenter.new(content_item)
  end
end
