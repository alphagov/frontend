class WorldwideOfficeController < ContentItemsController
  include Cacheable

  def show
    @presenter = WorldwideOfficePresenter.new(content_item)
  end
end
