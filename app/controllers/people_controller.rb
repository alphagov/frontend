class PeopleController < ContentItemsController
  include Cacheable

  layout "header_sidebar_content"

  def show
    @content_item_presenter = PersonPresenter.new(content_item)
  end
end
