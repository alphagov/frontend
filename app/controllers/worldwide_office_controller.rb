class WorldwideOfficeController < ContentItemsController
  include Cacheable

  layout "header_content_sidebar"

  def show
    @content_item_presenter = WorldwideOfficePresenter.new(content_item)
  end
end
