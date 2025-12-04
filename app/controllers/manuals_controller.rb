class ManualsController < ContentItemsController
  include Cacheable

  def show
    @manuals_presenter = ManualsPresenter.new(content_item)
  end
end
